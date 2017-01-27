package energyhack.dto.measurements;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class Measurement {

    @JsonProperty
    private String meterID;

    @JsonProperty
    private int day;

    @JsonProperty
    private int month;

    @JsonProperty
    private int year;

    @JsonProperty
    private double lowConsumptionSum;

    @JsonProperty
    private double highConsumptionSum;

    @JsonProperty
    private double maxConsumption;

    @JsonProperty
    private double laggingReactivePowerSum;

    @JsonProperty
    private double leadingReactivePowerSum;

    @JsonProperty
    private List<Double> laggingReactivePower;

    @JsonProperty
    private List<Double> leadingReactivePower;

    @JsonProperty
    private List<Double> consumption;
}
