package energyhack.dto.meters;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class Meters {

    @JsonProperty
    private List<MeterObject> meters;
}
