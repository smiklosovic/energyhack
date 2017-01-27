package energyhack.controller;

import static org.springframework.http.HttpStatus.OK;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import energyhack.dto.distributor.Distributors;
import energyhack.service.EnergyHackApiClient;

@RestController
public class EnergyHackController {

    @Autowired
    private EnergyHackApiClient energyHackApiClient;

    @GetMapping(value = "/distributors", produces = "application/json")
    public ResponseEntity<Distributors> getDistributors() {

        return new ResponseEntity<>(energyHackApiClient.getDistributors(), OK);
    }
}
