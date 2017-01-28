package energyhack.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import energyhack.dto.measurements.Measurements;
import energyhack.model.Model;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Service
public class EveryDayCostService {

    public List<Double> computeCostForEveryDay(Model model, Measurements measurements) {

        final double consumptionCost = model.getConsumptionCost(measurements) + model.getTax(measurements);

        List<Double> costUntilNow = new ArrayList<>();

        double costPerDay = consumptionCost / measurements.getMeasurements().size();

        for (int i = 1; i <= measurements.getMeasurements().size(); i++) {
            costUntilNow.add(costPerDay * i);
        }

        return costUntilNow;
    }
}