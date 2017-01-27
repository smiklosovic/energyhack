package energyhack.service;

import org.jboss.aerogear.unifiedpush.PushSender;
import org.jboss.aerogear.unifiedpush.message.MessageResponseCallback;
import org.jboss.aerogear.unifiedpush.message.UnifiedMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Service
public class EnergyHackPushMessageSender {

    @Autowired
    private PushSender pushSender;

    public void sendMessage(String message, MessageResponseCallback messageResponseCallback) {
        sendMessage(getDefaultMessage(message), messageResponseCallback);
    }

    public void sendMessage(String message) {
        sendMessage(getDefaultMessage(message), null);
    }

    public void sendMessage(UnifiedMessage unifiedMessage) {
        pushSender.send(unifiedMessage, null);
    }

    public void sendMessage(UnifiedMessage unifiedMessage, MessageResponseCallback messageResponseCallback) {

        if (messageResponseCallback == null) {
            pushSender.send(unifiedMessage);
        } else {
            pushSender.send(unifiedMessage, messageResponseCallback);
        }
    }

    public UnifiedMessage getDefaultMessage(String message) {
        return UnifiedMessage.withMessage()
            .alert(message)
            .sound("default")
            .badge("1")
            .userData("some_key", "with_value")
            .config()
            .timeToLive(60)
            .build();
    }
}
