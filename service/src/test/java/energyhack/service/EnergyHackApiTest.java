package energyhack.service;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import energyhack.service.EnergyHackApiClient;
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

    @Test
    public void testGetDistributors() {
        final Distributors distributors = energyHackApiClient.getDistributors();

        Assert.assertNotNull(distributors);
    }

    @Test
    public void testGetSupplier() {
        final Suppliers suppliers = energyHackApiClient.getSuppliers();

        Assert.assertNotNull(suppliers);
    }

    @Test
    public void testMeters() {
        final List<MeterObject> meters = energyHackApiClient.getMeters().getMeters();

        Assert.assertNotNull(meters);
    }

    @Test
    public void testMeterId() {
        final Meter meter = energyHackApiClient.getMeter(5);

        Assert.assertNotNull(meter);
    }

    @Test
    public void testMetersWithAddress() {

        // TODO

        final Meters metersWithAddress = energyHackApiClient.getMetersWithAddress("91501");

        Assert.assertNotNull(metersWithAddress);
    }

    @Test
    public void testMetersWithSupplierId() {

        final Meters metersWithSupplierID = energyHackApiClient.getMetersWithSupplierID(3);

        Assert.assertNotNull(metersWithSupplierID);
    }

    @Test
    public void testMetersDetail() {

        final Meter meterDetail = energyHackApiClient.getMeterDetail(3);

        Assert.assertNotNull(meterDetail);
    }

    @Test
    public void testGetMetersWithReservedCapacityMax() {
        final Meters metersWithReservedCapacityMax = energyHackApiClient.getMetersWithReservedCapacityMax(3);

        Assert.assertNotNull(metersWithReservedCapacityMax);
    }

    @Test
    public void testGetMetersWithReservedCapacityMin() {
        final Meters metersWithReservedCapacityMin = energyHackApiClient.getMetersWithReservedCapacityMin(3);

        Assert.assertNotNull(metersWithReservedCapacityMin);
    }

    @Test
    public void testGetMetersWithTarif() {
        final Meters metersWithTarif = energyHackApiClient.getMetersWithTarif(3);

        Assert.assertNotNull(metersWithTarif);
    }
}
