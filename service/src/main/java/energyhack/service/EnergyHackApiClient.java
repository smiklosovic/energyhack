package energyhack.service;

import static java.util.Arrays.asList;
import static java.util.stream.Collectors.joining;
import static org.springframework.http.HttpMethod.GET;
import static org.springframework.http.MediaType.APPLICATION_FORM_URLENCODED;
import static org.springframework.http.MediaType.APPLICATION_JSON;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import energyhack.dto.distributor.Distributors;
import energyhack.dto.meters.Address;
import energyhack.dto.meters.Meter;
import energyhack.dto.meters.MeterField;
import energyhack.dto.meters.Meters;
import energyhack.dto.supplier.Suppliers;
import energyhack.utils.JsonSerializer;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Service
public class EnergyHackApiClient {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private JsonSerializer jsonSerializer;

    public String getServiceUrl() {
        return "https://api.energyhack.sk/";
    }

    //
    // Distributors
    //

    public Distributors getDistributors() {
        return doGet(getServiceUrl() + "distributors/", Distributors.class).getBody();
    }

    //
    // Suppliers
    //

    public Suppliers getSuppliers() {
        return doGet(getServiceUrl() + "suppliers/", Suppliers.class).getBody();
    }

    ///
    /// Meters
    ///

    public Meter getMeter(int meterID) {
        return doGet(getServiceUrl() + "meters/" + meterID, Meter.class).getBody();
    }

    public Meters getMeters() {
        return doGet(getServiceUrl() + "meters", Meters.class).getBody();
    }

    public Meters getMetersWithAddress(String zip) {

        Address address = new Address();
        address.setZip(zip);

        return getMetersWithAddress(address);
    }

    public Meters getMetersWithAddress(Address address) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("address", jsonSerializer.oneLine(jsonSerializer.objectToJson(address)))
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meters getMetersWithTarif(int tarif) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("tarif", tarif)
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meters getMetersWithSupplierID(int supplierID) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("supplierID", supplierID)
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meters getMetersWithReservedCapacityMin(int reservedCapacityMin) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("reservedCapacityMin", reservedCapacityMin)
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meters getMetersWithReservedCapacityMax(int reservedCapacityMax) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("reservedCapacityMax", reservedCapacityMax)
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meter getMeterDetail(int meterId) {
        return doGet(getServiceUrl() + "meters/" + meterId, Meter.class).getBody();
    }

    ///
    /// Measurements
    ///

    public Meters getMeasurementsFromTo(String from, String to) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("from", from)
            .queryParam("to", to)
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    public Meters getMeasurementsFromTo(String from, String to, MeterField... fields) {

        final String uri = UriComponentsBuilder.fromHttpUrl(getServiceUrl() + "meters")
            .queryParam("from", from)
            .queryParam("to", to)
            .queryParam("fields", asList(fields).stream().map(MeterField::toString).collect(joining(",")))
            .build().encode().toUriString();

        return doGet(uri, Meters.class).getBody();
    }

    //
    // GET
    //

    public <T> ResponseEntity<T> doGet(String path, Class<T> responseModel) {
        return doGet(path, responseModel, getDefaultHeaders());
    }

    public <T> ResponseEntity<T> doGet(String path,
                                       Class<T> responseModel,
                                       Map<String, ?> uriVariables) {

        return restTemplate.exchange(getServiceUrl() + path,
                                     GET,
                                     new HttpEntity<>(getDefaultHeaders()),
                                     responseModel,
                                     uriVariables);
    }

    public <T> ResponseEntity<T> doGet(String path,
                                       Class<T> responseModel,
                                       HttpHeaders httpHeaders) {

        return restTemplate.exchange(path,
                                     GET,
                                     new HttpEntity<>(httpHeaders),
                                     responseModel);
    }

    //
    // helpers
    //

    private HttpEntity<String> getHttpEntity(String entity) {
        return getHttpEntity(entity, getDefaultHeaders());
    }

    private <T> HttpEntity<T> getHttpEntity(T entity, HttpHeaders httpHeaders) {
        return new HttpEntity<T>(entity, httpHeaders);
    }

    private HttpHeaders getDefaultHeaders() {
        final HttpHeaders httpHeaders = new HttpHeaders();

        httpHeaders.setAccept(asList(MediaType.APPLICATION_JSON_UTF8));

        return httpHeaders;
    }
}
