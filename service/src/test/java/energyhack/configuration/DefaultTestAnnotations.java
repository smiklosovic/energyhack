package energyhack.configuration;

import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;

import energyhack.EnergyHack;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@SpringBootTest(classes = { EnergyHack.class }, webEnvironment = RANDOM_PORT)
@TestPropertySource(locations = "classpath:application.properties")
public @interface DefaultTestAnnotations {

}
