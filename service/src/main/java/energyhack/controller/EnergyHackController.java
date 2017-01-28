package energyhack.controller;

import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.OK;

import javax.validation.Valid;

import org.jboss.aerogear.unifiedpush.message.MessageResponseCallback;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.annotation.JsonFormat;

import energyhack.dto.ConsumptionGraph;
import energyhack.dto.Notification;
import energyhack.dto.distributor.Distributors;
import energyhack.service.ConsumptionService;
import energyhack.service.EnergyHackApiClient;
import energyhack.service.EnergyHackPushMessageSender;

@RestController
public class EnergyHackController {

    private static final Logger logger = LoggerFactory.getLogger(EnergyHackController.class);

    @Autowired
    private EnergyHackApiClient energyHackApiClient;

    @Autowired
    private ConsumptionService consumptionService;

    @Autowired
    private EnergyHackPushMessageSender energyHackPushMessageSender;

    @GetMapping(value = "/distributors", produces = "application/json")
    public ResponseEntity<Distributors> getDistributors() {

        return new ResponseEntity<>(energyHackApiClient.getDistributors(), OK);
    }

    @GetMapping(value = "/grafSpotreba/{meterId}/{month}/{dayOfMonth}")
    public ResponseEntity<ConsumptionGraph> getConsumptionGraph(@PathVariable int meterId,
                                                                @PathVariable int month,
                                                                @PathVariable int dayOfMonth) {

        ConsumptionGraph consumptionGraph = consumptionService.getConsumptionGraph(meterId, month, dayOfMonth);

        return new ResponseEntity<>(consumptionGraph, OK);
    }

    @GetMapping(value = "/grafSpotreba/{meterId}/{month}")
    public ResponseEntity<ConsumptionGraph> getConsumptionGraph(@PathVariable int meterId, @PathVariable int month) {

        ConsumptionGraph consumptionGraph = consumptionService.getConsumptionGraph(meterId, month, 15);

        return new ResponseEntity<>(consumptionGraph, OK);
    }

    @PostMapping(value = "/notification", consumes = "application/json")
    public ResponseEntity<Void> sendNotification(@Valid @RequestBody @JsonFormat Notification notification) {

        NotificationResultCallback notificationResultCallback = new NotificationResultCallback();

        energyHackPushMessageSender.sendMessage(notification, notificationResultCallback);

        logger.info("[sendNotification] - {}", notification);

        return notificationResultCallback.getResponseEntity();
    }

    public static class NotificationResultCallback implements MessageResponseCallback {

        ResponseEntity<Void> responseEntity = new ResponseEntity<>(BAD_REQUEST);

        public ResponseEntity<Void> getResponseEntity() {
            return responseEntity;
        }

        @Override
        public void onComplete() {
            responseEntity = new ResponseEntity<>(OK);
        }
    }
}
