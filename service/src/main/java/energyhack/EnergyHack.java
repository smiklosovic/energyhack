package energyhack;

import static org.springframework.boot.SpringApplication.run;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

import javax.annotation.PreDestroy;

@SpringBootApplication
public class EnergyHack {

    private static ConfigurableApplicationContext context;

    public static void main(String[] args) {
        context = run(EnergyHack.class, args);
    }

    @PreDestroy
    public void shutDown() {
        SpringApplication.exit(context, () -> 0);
    }
}
