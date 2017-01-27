package energyhack.configuration;

import org.jboss.aerogear.unifiedpush.DefaultPushSender;
import org.jboss.aerogear.unifiedpush.PushSender;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
@Configuration
public class EnergyHackConfiguration {

    @Value("${push.server:https://ups.miklosovic.net:8443/ag-push/}")
    private String pushServerUrl;

    @Value("${push.applicationId}")
    private String pushApplicationId;

    @Value("${push.masterSecret}")
    private String pushMasterSecret;

    @Bean
    public PushSender getPushSender() {

        return DefaultPushSender
            .withRootServerURL(pushServerUrl)
            .pushApplicationId(pushApplicationId)
            .masterSecret(pushMasterSecret)
            .build();
    }
}
