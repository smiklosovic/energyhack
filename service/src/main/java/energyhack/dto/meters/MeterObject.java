package energyhack.dto.meters;

import com.fasterxml.jackson.annotation.JsonProperty;

import energyhack.dto.distributor.Distributor;
import energyhack.dto.supplier.Supplier;
import lombok.Data;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Data
public class MeterObject {

    @JsonProperty
    private String meterID;

    @JsonProperty
    private Address address;

    @JsonProperty
    private int reservedCapacity;

    @JsonProperty
    private Supplier supplier;

    @JsonProperty
    private Distributor distributor;

    @JsonProperty
    private int tariff;
}
