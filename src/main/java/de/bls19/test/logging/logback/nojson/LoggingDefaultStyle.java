package de.bls19.test.logging.logback.nojson;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class LoggingDefaultStyle {


  private static final Logger LOGGER = LogManager.getLogger(LoggingDefaultStyle.class);

  @Scheduled(fixedRate = 30000)
  public void logMessage() {
    LOGGER.info("default style is still logging ...");
  }

}
