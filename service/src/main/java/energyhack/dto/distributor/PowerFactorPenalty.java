package energyhack.dto.distributor;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class PowerFactorPenalty {

    @JsonProperty
    private double start;

    @JsonProperty
    private double end;

    @JsonProperty
    private double modifier;
}
