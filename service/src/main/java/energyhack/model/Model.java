package energyhack.model;

import static java.util.stream.Collectors.toList;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import energyhack.dto.distributor.Distributor;
import energyhack.dto.distributor.PowerFactorPenalty;
import energyhack.dto.measurements.Measurements;
import energyhack.dto.meters.Meter;
import energyhack.dto.meters.MeterField;
import energyhack.dto.meters.MeterObject;
import energyhack.dto.meters.Meters;
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

    public void init(String meterId) {
        init(Integer.parseInt(meterId));
    }

    public void init(int meterId) {
        meter = getMeter(meterId);

        distributor = getDistributor();

        supplier = getSupplier();
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

    public double getConsumptionCostWithoutLoss(double consumptionSum) {
        return consumptionSum * distributor.getCostConsumptionWithoutLoss();
    }

    public double getConsumptionCostWithLoss(double consumptionSum) {
        return consumptionSum * distributor.getCostConsumptionWithLoss();
    }

    public double getReservedCapacityCost() {
        return meter.getReservedCapacity() * distributor.getCostReservedCapacity();
    }

    public double getReservedCapacityOvershootCost(double maxConsumption) {

        if ((maxConsumption - meter.getReservedCapacity()) <= 0) {
            return 0;
        }

        return (maxConsumption - meter.getReservedCapacity()) * distributor.getCostReservedCapacityOvershoot();
    }

    public double getLeadingReactivePowerCost(double leadingReactivePowerSum) {
        return leadingReactivePowerSum * distributor.getCostLeadingReactivePower();
    }

    public double getLaggingReactivePowerCost(double laggingReactivePowerSum, double consumptionSum) {

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
        double sum2 = meter.getReservedCapacity();

        return (sum2 + (sum1 * modifier2)) * modifier1;
    }

    public double getOCTEcost(double consumptionSum) {
        return consumptionSum * distributor.getCostOKTE();
    }

    public double getConsumptionCost(double lowConsumptionSum, double highConsumptionSum) {

        double consumptionSum = lowConsumptionSum + highConsumptionSum;

        double ratio = consumptionSum / supplier.getTariffValues().get(meter.getTariff() - 1);

        double modifier = 0;

        if (ratio < (1.0 - supplier.getTolerance())) {
            modifier = supplier.getCostModifierUnderconsumption();
        } else if (ratio > (1.0 + supplier.getTolerance())) {
            modifier = supplier.getCostModifierOverconsumption();
        } else {
            modifier = 1;
        }

        return (lowConsumptionSum * supplier.getCostLow() * modifier)
            + (highConsumptionSum * supplier.getCostHigh() * modifier);
    }
}
