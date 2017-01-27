package energyhack.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Configuration
public class RestTemplateConfiguration {

    private static final Logger logger = LoggerFactory.getLogger(RestTemplateConfiguration.class);

    @Bean
    public RestTemplate defaultRestTemplate() {
        logger.debug("Default RestTemplate initialization.");
        RestTemplate restTemplate = new RestTemplate();
        //restTemplate.setMessageConverters(getMessageConverters());
        return new RestTemplate();
    }

    private List<HttpMessageConverter<?>> getMessageConverters() {
        List<HttpMessageConverter<?>> converters = new ArrayList<>();
        converters.add(new MappingJackson2HttpMessageConverter());
        return converters;
    }
}
