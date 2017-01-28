package energyhack.configuration;

import java.util.ArrayList;
import java.util.List;

import org.jboss.aerogear.unifiedpush.DefaultPushSender;
import org.jboss.aerogear.unifiedpush.PushSender;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

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

    @Bean
    public RestTemplate defaultRestTemplate() {

        List<HttpMessageConverter<?>> converters = new ArrayList<>();
        converters.add(new MappingJackson2HttpMessageConverter());

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setMessageConverters(converters);
        
        return restTemplate;
    }
}
