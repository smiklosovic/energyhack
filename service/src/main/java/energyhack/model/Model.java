package energyhack.model;

import static java.util.stream.Collectors.toList;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.DoubleStream;

import energyhack.dto.distributor.Distributor;
import energyhack.dto.distributor.PowerFactorPenalty;
import energyhack.dto.measurements.Measurement;
import energyhack.dto.measurements.Measurements;
import energyhack.dto.meters.MeterField;
import energyhack.dto.meters.MeterObject;
import energyhack.dto.supplier.Supplier;
import energyhack.service.EnergyHackApiClient;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
public class Model {

    private EnergyHackApiClient energyHackApiClient;

    public Supplier supplier;

    public Distributor distributor;

    public MeterObject meter;

    public Model(MeterObject meter, EnergyHackApiClient energyHackApiClient) {
        this.meter = meter;
        this.energyHackApiClient = energyHackApiClient;
    }

    public Model init() {
        init(Integer.parseInt(meter.getMeterID()));
        return this;
    }

    public Model init(int meterId) {
        meter = getMeter(meterId);

        distributor = getDistributor();

        supplier = getSupplier();

        return this;
    }

    public MeterObject getMeter(int meterID) {
        return energyHackApiClient.getMeter(meterID).getMeter();
    }

    public Supplier getSupplier() {
        final List<Supplier> suppliers = energyHackApiClient
            .getSuppliers()
            .getSuppliers()
            .stream()
            .filter(supplier -> supplier.getSupplierID().equals(meter.getSupplier().getSupplierID()))
            .collect(toList());

        return suppliers.size() > 0 ? suppliers.get(0) : null;
    }

    public Distributor getDistributor() {
        final List<Distributor> distributors = energyHackApiClient
            .getDistributors()
            .getDistributors()
            .stream()
            .filter(distributor -> distributor.getDistributorID().equals(meter.getDistributor().getDistributorID()))
            .collect(toList());

        return distributors.size() > 0 ? distributors.get(0) : null;
    }

    public Measurements getMonthlyConsumptions(String from, String to, MeterField... meterFields) {

        return energyHackApiClient.getMeasurementsFromTo(meter.getMeterID(),
                                                         from,
                                                         to,
                                                         meterFields);

    }

    // 1 Monthly cost for consumption without loss

    public double getMonthlyCostForConsumptionWithoutLoss(Measurements measurements) {

        double first = getMeterMonthConsumption(measurements);

        double second = distributor.getCostConsumptionWithoutLoss();

        return first * second;
    }

    // 2 Monthly cost for consumption with loss

    public double getMonthlyCostForConsumptionWithLoss(Measurements measurements) {
        return getMeterMonthConsumption(measurements) * distributor.getCostConsumptionWithLoss();
    }

    // 3 Monthly cost for reserved capacity

    public double getReservedCapacityCost() {
        return meter.getReservedCapacity() * distributor.getCostReservedCapacity();
    }

    // 4 Monthly cost for overshooting reserved capacity

    public double getReservedCapacityOvershootCost(Measurements measurements) {

        double result = getMeasurementMaxConsumption(measurements) * 4 - meter.getReservedCapacity();

        return result * distributor.getCostReservedCapacityOvershoot();
    }

    // 5 Monthly cost for leading reactive power (Jalová dodávka)

    public double getLeadingReactivePowerCost(Measurements measurements) {

        final double leadingReactivePowerSumForAllDaysInMonth =
            getLeadingReactivePowerSumForAllDaysInMonth(measurements);

        return leadingReactivePowerSumForAllDaysInMonth * distributor.getCostLeadingReactivePower();
    }

    // 6 Monthly cost for not effective consumption

    public double getLaggingReactivePowerCost(Measurements measurements) {

        double laggingReactivePowerSum = getLaggingReactivePowerSumForAllDaysInMonth(measurements);
        double consumptionSum = getMeterMonthConsumption(measurements);

        double ratio = laggingReactivePowerSum / consumptionSum;

        double modifier1 = 0;

        for (PowerFactorPenalty powerFactorPenalty : distributor.getPowerFactorPenalties()) {
            if (powerFactorPenalty.getStart() <= ratio && powerFactorPenalty.getEnd() >= ratio) {
                modifier1 = powerFactorPenalty.getModifier();
                break;
            }
        }

        double modifier2 = 0;

        if (modifier1 != 0) {
            modifier2 = distributor.getCostModifierCosFi();
        }

        double sum1 = consumptionSum * distributor.getCostConsumptionWithoutLoss();
        double sum3 = meter.getReservedCapacity();

        return (sum3 + (sum1 * modifier2)) * modifier1;
    }

    ////
    ////
    //// 7 OCTE
    ////
    ////

    public double getOCTEcost(Measurements measurements) {
        return getMeterMonthConsumption(measurements) * distributor.getCostOKTE();
    }

    /////
    /////
    ///// 8 getConsumptionCost
    /////
    /////

    public double getConsumptionCost(Measurements measurements) {

        double meterMonthConsumption = getMeterMonthConsumption(measurements);

        double ratio = meterMonthConsumption / supplier.getTariffValues().get(meter.getTariff() - 1);

        double modifier = 0;

        if (ratio < (1.0 - supplier.getTolerance())) {
            modifier = supplier.getCostModifierUnderconsumption();
        } else if (ratio > (1.0 + supplier.getTolerance())) {
            modifier = supplier.getCostModifierOverconsumption();
        } else {
            modifier = 1;
        }

        double lowConsumptionSum = getMeterMonthConsumptionLow(measurements);

        double highConsumptionSum = getMeterMonthConsumptionHigh(measurements);

        return (lowConsumptionSum * supplier.getCostLow() * modifier)
            + (highConsumptionSum * supplier.getCostHigh() * modifier);
    }

    //
    //
    // TAX
    //
    //

    public double getTax(Measurements measurements) {
        return getMeterMonthConsumption(measurements) * supplier.getCostTax();
    }

    // helpers

    private double getMeterMonthConsumptionHigh(Measurements measurements) {
        return measurements.getMeasurements().stream()
            .map(Measurement::getHighConsumptionSum)
            .mapToDouble(Double::doubleValue)
            .sum();
    }

    private double getMeterMonthConsumptionLow(Measurements measurements) {
        return measurements.getMeasurements().stream()
            .map(Measurement::getLowConsumptionSum)
            .mapToDouble(Double::doubleValue)
            .sum();
    }

    private double getMeterMonthConsumption(Measurements measurements) {
        final List<Double> collect = measurements.getMeasurements().stream()
            .map(measurement -> measurement.getHighConsumptionSum() + measurement.getLowConsumptionSum())
            .collect(Collectors.toList());

        return collect.stream().mapToDouble(Double::doubleValue).sum();
    }

    private double getMeasurementMaxConsumption(Measurements measurements) {
        final double asDouble =
            measurements.getMeasurements().stream().mapToDouble(Measurement::getMaxConsumption).max().getAsDouble();

        return asDouble;
    }

    private double getLeadingReactivePowerSumForAllDaysInMonth(Measurements measurements) {
        return measurements.getMeasurements().stream().mapToDouble(Measurement::getLeadingReactivePowerSum).sum();
    }

    private double getLaggingReactivePowerSumForAllDaysInMonth(Measurements measurements) {
        return measurements.getMeasurements().stream().mapToDouble(Measurement::getLaggingReactivePowerSum).sum();
    }

}
