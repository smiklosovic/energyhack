package energyhack.service;

import static org.junit.Assert.assertTrue;

import org.jboss.aerogear.unifiedpush.message.UnifiedMessage;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import energyhack.configuration.DefaultTestAnnotations;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@DefaultTestAnnotations
@RunWith(SpringJUnit4ClassRunner.class)
public class PushNotificationTest {

    @Autowired
    private EnergyHackPushMessageSender energyHackPushMessageSender;

    @Test
    public void testSendingPushNotification() {

        final UnifiedMessage message = energyHackPushMessageSender.getDefaultMessage("hello there");

        energyHackPushMessageSender.sendMessage(message, () -> assertTrue(true));
    }
}
