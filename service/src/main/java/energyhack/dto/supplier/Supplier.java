package energyhack.dto.supplier;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class Supplier {

    @JsonProperty
    private String supplierID;

    @JsonProperty
    private List<Integer> tariffValues;

    @JsonProperty
    private String name;

    @JsonProperty
    private double costLow;

    @JsonProperty
    private double costHigh;

    @JsonProperty
    private double tolerance;

    @JsonProperty
    private double costModifierOverconsumption;

    @JsonProperty
    private double costModifierUnderconsumption;

    @JsonProperty
    private double costTax;
}
