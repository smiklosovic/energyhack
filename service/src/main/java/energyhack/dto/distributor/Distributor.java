package energyhack.dto.distributor;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class Distributor {

    @JsonProperty
    private String distributorID;

    @JsonProperty
    private String name;

    @JsonProperty
    private double costConsumptionWithoutLoss;

    @JsonProperty
    private double costConsumptionWithLoss;

    @JsonProperty
    private double costReservedCapacity;

    @JsonProperty
    private double costReservedCapacityOvershoot;

    @JsonProperty
    private double costLeadingReactivePower;

    @JsonProperty
    private double costModifierCosFi;

    @JsonProperty
    private double costOKTE;

    @JsonProperty
    private List<PowerFactorPenalty> powerFactorPenalties;
}
