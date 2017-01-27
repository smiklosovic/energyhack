package energyhack.utils;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.datatype.joda.JodaModule;

@Component
public class JsonSerializer {

    private static final Logger logger = LoggerFactory.getLogger(JsonSerializer.class);

    @Autowired
    private ObjectMapper objectMapper;

    public JsonSerializer() {
        super();
    }

    public JsonSerializer(ObjectMapper objectMapper) {
        super();
        this.objectMapper = objectMapper;
    }

    public JsonSerializer(boolean staticInitialization) {
        super();
        if (staticInitialization) {
            objectMapper = new ObjectMapper();
            objectMapper.registerModule(new JodaModule());
            objectMapper
                .configure(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
            objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
        }
    }

    // "Serialization" Section

    public String objectToJson(Object object) {
        return objectToJson(objectMapper.writerWithDefaultPrettyPrinter(), object);
    }

    public String objectToJson(ObjectWriter objectWriter, Object obj) {

        String json = null;

        try {
            json = objectWriter.writeValueAsString(obj);
        } catch (final JsonProcessingException e) {
            logger.error("Error in objectToJson()", e);
        }
        return json;
    }

    public <T> String objectListToJson(List<T> list) {
        return objectListToJson(objectMapper.writer(), list);
    }

    public <T> String objectListToJson(ObjectWriter objectWriter, List<T> list) {
        try {
            return objectWriter.writeValueAsString(list);
        } catch (final JsonProcessingException e) {
            logger.error("Error in objectListToJson()", e);
        }
        return null;
    }

    // "Deserialization" Section

    public <T> T jsonToObject(String json, Class<T> clazz) {
        return jsonToObject(objectMapper, json, clazz);
    }

    public <T> T jsonToObject(ObjectMapper objectMapper, String json, Class<T> clazz) {
        try {
            return objectMapper.readValue(json, clazz);
        } catch (final IOException e) {
            logger.error("Error in jsonToObject()", e);
        }
        return null;
    }

    public Object jsonToObjectTree(String json) throws IOException {
        return jsonToObjectTree(objectMapper, json);
    }

    public Object jsonToObjectTree(ObjectMapper objectMapper, String json) throws IOException {
        return objectMapper.readTree(json);
    }

    public <T> List<T> jsonToObjectList(String json, Class<T> clazz) {
        return jsonToObjectList(objectMapper, json, clazz);
    }

    public <T> List<T> jsonToObjectList(ObjectMapper objectMapper, String json, Class<T> clazz) {
        try {
            return objectMapper
                .readValue(json, objectMapper.getTypeFactory().constructCollectionType(List.class, clazz));
        } catch (final IOException e) {
            logger.error("Error in jsonToObjectList()", e);
        }
        return null;
    }

    public <T> T bytesToObject(byte[] payload, Class<T> clazz) {
        return bytesToObject(objectMapper, payload, clazz);
    }

    public <T> T bytesToObject(ObjectMapper objectMapper, byte[] payload, Class<T> clazz) {
        try {
            return objectMapper.readValue(payload, clazz);
        } catch (final IOException e) {
            logger.error("Error in bytesToObject()", e);
        }

        return null;
    }

    public String oneLine(String json) {
        return json.replaceAll(System.lineSeparator(), "");
    }
}

