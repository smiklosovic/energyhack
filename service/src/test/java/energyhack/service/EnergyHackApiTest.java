package energyhack.service;

import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import energyhack.dto.ConsumptionPriceGraph;
import energyhack.dto.measurements.Measurements;
import energyhack.dto.meters.MeterField;
import energyhack.model.Model;
import energyhack.configuration.DefaultTestAnnotations;
import energyhack.dto.distributor.Distributors;
import energyhack.dto.meters.Meter;
import energyhack.dto.meters.MeterObject;
import energyhack.dto.meters.Meters;
import energyhack.dto.supplier.Suppliers;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@RunWith(SpringJUnit4ClassRunner.class)
@DefaultTestAnnotations
public class EnergyHackApiTest {

    @Autowired
    private EnergyHackApiClient energyHackApiClient;

    @Autowired
    private EveryDayCostService everyDayCostService;

    @Autowired
    private ConsumptionService consumptionService;

    @Test
    public void testGetDistributors() {
        final Distributors distributors = energyHackApiClient.getDistributors();

        assertNotNull(distributors);
    }

    @Test
    public void testGetSupplier() {
        final Suppliers suppliers = energyHackApiClient.getSuppliers();

        assertNotNull(suppliers);
    }

    @Test
    public void testMeters() {
        final List<MeterObject> meters = energyHackApiClient.getMeters().getMeters();

        assertNotNull(meters);
    }

    @Test
    public void testMeterId() {
        final Meter meter = energyHackApiClient.getMeter(5);

        assertNotNull(meter);
    }

    @Test
    public void testMetersWithAddress() {

        // TODO

        final Meters metersWithAddress = energyHackApiClient.getMetersWithAddress("91501");

        assertNotNull(metersWithAddress);
    }

    @Test
    public void testMetersWithSupplierId() {

        final Meters metersWithSupplierID = energyHackApiClient.getMetersWithSupplierID(3);

        assertNotNull(metersWithSupplierID);
    }

    @Test
    public void testMetersDetail() {

        final Meter meterDetail = energyHackApiClient.getMeterDetail(3);

        assertNotNull(meterDetail);
    }

    @Test
    public void testGetMetersWithReservedCapacityMax() {
        final Meters metersWithReservedCapacityMax = energyHackApiClient.getMetersWithReservedCapacityMax(3);

        assertNotNull(metersWithReservedCapacityMax);
    }

    @Test
    public void testGetMetersWithReservedCapacityMin() {
        final Meters metersWithReservedCapacityMin = energyHackApiClient.getMetersWithReservedCapacityMin(3);

        assertNotNull(metersWithReservedCapacityMin);
    }

    @Test
    public void testGetMetersWithTarif() {
        final Meters metersWithTarif = energyHackApiClient.getMetersWithTarif(3);

        assertNotNull(metersWithTarif);
    }

    @Test
    public void testGetMeasurementsFromTo() {

        Meter meterDetail = energyHackApiClient.getMeter(1);

        Measurements measurementsFromTo = energyHackApiClient.getMeasurementsFromTo(meterDetail.getMeter().getMeterID(),
                                                                                    "01-2016", "02-2016");
        assertNotNull(measurementsFromTo);
    }

    @Test
    public void testGetMeasurementsFromToOther() {
        Meter meterDetail = energyHackApiClient.getMeter(1);

        Measurements measurementsFromTo = energyHackApiClient.getMeasurementsFromTo(meterDetail.getMeter().getMeterID(),
                                                                                    "01-2016", "02-2016",
                                                                                    MeterField.CONSUMPTION);

        assertNotNull(measurementsFromTo);
    }

    @Test
    public void testConsumptionCost() {
        Meter meter = energyHackApiClient.getMeter(1);

        Measurements measurementsFromTo = energyHackApiClient.getMeasurementsFromTo(meter.getMeter().getMeterID(),
                                                                                    "01-2016", "01-2016");

        Model model = new Model(meter.getMeter(), energyHackApiClient);

        model.init();

        // 1

        double monthlyCostForConsumptionWithoutLoss = model.getMonthlyCostForConsumptionWithoutLoss(measurementsFromTo);

        // 2

        final double monthlyCostForConsumptionWithLoss = model.getMonthlyCostForConsumptionWithLoss(measurementsFromTo);

        // 3

        final double reservedCapacityCost = model.getReservedCapacityCost();

        // 4

        final double reservedCapacityOvershootCost = model.getReservedCapacityOvershootCost(measurementsFromTo);

        // 5

        final double leadingReactivePowerCost = model.getLeadingReactivePowerCost(measurementsFromTo);

        // 6

        final double laggingReactivePowerCost = model.getLaggingReactivePowerCost(measurementsFromTo);

        // 7

        final double octEcost = model.getOCTEcost(measurementsFromTo);

        // 8

        final double consumptionCost = model.getConsumptionCost(measurementsFromTo);

        // 9 - tax

        final double tax = model.getTax(measurementsFromTo);

        final List<Double> costForEveryDay = everyDayCostService.computeCostForEveryDay(model, measurementsFromTo);

        ConsumptionPriceGraph consumptionGraph = consumptionService.getConsumptionPriceGraph(1, 6, 15);

        System.out.println("end");
    }
}
