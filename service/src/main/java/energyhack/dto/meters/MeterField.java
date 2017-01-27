package energyhack.dto.meters;

/**
 * @author <a href="mailto:Stefan.Miklosovic@sk.ibm.com">Stefan Miklosovic</a>
 */
public enum MeterField {

    CONSUMPTION("consumption"),
    LEADING_REACTIVE_POWER("leadingReactivePower"),
    LAGGING_REACTIVE_POWER("laggingReactivePower");

    String name;

    MeterField(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return name;
    }
}
