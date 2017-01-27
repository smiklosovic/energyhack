package energyhack.dto.distributor;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class Distributors {

    @JsonProperty
    private List<Distributor> distributors;
}
