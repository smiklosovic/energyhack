package energyhack.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class ConsumptionPriceGraph {

    @JsonProperty
    private List<Double> current;

    @JsonProperty
    private List<Double> prediction;
}
