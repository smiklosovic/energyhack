package energyhack.controller;

import static org.springframework.http.HttpStatus.OK;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import energyhack.service.EnergyHackApiClient;

@RestController
public class EnergyHackController {

    @Autowired
    private EnergyHackApiClient energyHackApiClient;

    @GetMapping("/test")
    public ResponseEntity<String> getTest() {

        return new ResponseEntity<>("test", OK);
    }
}
