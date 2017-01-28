package energyhack.service;

import static java.lang.Math.max;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import energyhack.dto.measurements.Measurements;
import energyhack.model.Model;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Service
public class PredictionService {

    @Autowired
    private EveryDayCostService everyDayCostService;

    public List<Double> computePredictions(int day, List<Double> averagePast, List<Double> costsPerDay, int daysToFuture, int daysFromPast) {

        List<Double> costs = new ArrayList<>(costsPerDay).subList(0, day);

        for (int i = 0; i < daysToFuture; i++) {
            double newPrediction = computeMovingAverage(costs, daysFromPast);
            costs.add(averagePast.get(costs.size()-1) + (averagePast.get(costs.size()-1) - (averagePast.get(costs.size()-2))));
        }

        return costs.stream().skip(max(0, costs.size() - daysToFuture)).collect(toList());
    }

    private double computeMovingAverage(List<Double> costs, int daysFromPast) {
        return costs.stream()
            .skip(max(0, costs.size() - daysFromPast))
            .mapToDouble(Double::doubleValue)
            .average()
            .getAsDouble();
    }

    public List<Double> computePredictions(Model model, Measurements... previousMeasurements) {

        final List<List<Double>> costsForAllMonthPerEveryDay = asList(previousMeasurements).stream()
            .map(measurement -> everyDayCostService.computeCostForEveryDay(model, measurement))
            .collect(toList());

        return reduce(costsForAllMonthPerEveryDay);
    }

    public List<Double> reduce(List<List<Double>> costsForAllMonthPerEveryDay) {

        double numberOfMonths = costsForAllMonthPerEveryDay.size();

        double numberOfDaysInMonth = costsForAllMonthPerEveryDay.get(0).size();

        List<Double> result = new ArrayList<>();

        for (int i = 0; i < numberOfDaysInMonth; i++) {
            double dayAverage = 0;

            for (int j = 0; j < numberOfMonths; j++) {
                dayAverage += costsForAllMonthPerEveryDay.get(j).get(i);
            }

            result.add(dayAverage / numberOfMonths);
        }

        return result;
    }
}
