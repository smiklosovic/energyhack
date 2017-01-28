package energyhack.service;

import static java.lang.String.format;
import static java.util.stream.Collectors.toList;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import energyhack.dto.ConsumptionGraph;
import energyhack.dto.measurements.Measurement;
import energyhack.dto.measurements.Measurements;
import energyhack.dto.meters.Meter;
import energyhack.dto.meters.MeterObject;
import energyhack.model.Model;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Service
public class ConsumptionService {

    @Autowired
    private EnergyHackApiClient energyHackApiClient;

    @Autowired
    private EveryDayCostService everyDayCostService;

    @Autowired
    private PredictionService predictionService;

    public ConsumptionGraph getConsumptionGraph(int meterId, int month, int dayOfMonth) {

        final MeterObject meterObject = energyHackApiClient.getMeterObject(meterId);

        Model model = new Model(meterObject, energyHackApiClient).init();

        String currentMonth = format("%02d-2016", month);
        String oneMonthBackMonth = format("%02d-2016", month - 1);
        String twoMonthsBackMonth = format("%02d-2016", month - 2);
        String threeMonthsBackMonth = format("%02d-2016", month - 3);

        Measurements current = slice(getMeasurements(meterId, currentMonth));

        Measurements oneBack = slice(getMeasurements(meterId, oneMonthBackMonth));

        Measurements twoBack = slice(getMeasurements(meterId, twoMonthsBackMonth));

        Measurements threeBack = slice(getMeasurements(meterId, threeMonthsBackMonth));

        ConsumptionGraph consumptionGraph = new ConsumptionGraph();

        List<Double> costEveryDay = everyDayCostService.computeCostForEveryDay(model, current);

        final List<Double> averagePast = predictionService.computePredictions(model, oneBack, twoBack, threeBack);

        final List<Double> predictions = predictionService.computePredictions(dayOfMonth, averagePast, costEveryDay, 5, 2);

        consumptionGraph.setCurrent(costEveryDay);
        consumptionGraph.setPrediction(predictions);

        return consumptionGraph;
    }

    private Measurements getMeasurements(int meterId, String month) {
        return energyHackApiClient.getMeasurementsFromTo(meterId, month, month);
    }

    private Measurements slice(Measurements measurements) {
        Measurements toReturn = new Measurements();

        toReturn.setMeasurements(measurements.getMeasurements().stream().limit(28).collect(toList()));

        return toReturn;
    }
}
