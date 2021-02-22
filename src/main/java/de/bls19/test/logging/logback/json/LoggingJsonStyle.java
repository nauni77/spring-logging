package de.bls19.test.logging.logback.json;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class LoggingJsonStyle {

  private static final Logger LOGGER = LogManager.getLogger(LoggingJsonStyle.class);

  @Scheduled(fixedRate = 1000)
  public void logMessage() {
    LOGGER.info("json style is still logging ...");
  }

}
