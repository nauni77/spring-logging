package de.bls19.test.logging;

import java.util.concurrent.TimeUnit;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class LoggingApplicationTests {

	private static final Logger LOGGER = LogManager.getLogger(LoggingApplicationTests.class);

	@Test
	void justIfItsStarting() {

		LOGGER.info("start method: ustIfItsStarting");

		try {
			TimeUnit.SECONDS.sleep(10);
		} catch (InterruptedException ie) {
			Thread.currentThread().interrupt();
		}

		LOGGER.info("end method: ustIfItsStarting");
	}

}
