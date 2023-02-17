/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package progetto.server;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@SpringBootTest
public class CommonTest {

	private static Logger log = LogManager.getLogger();

	@ParameterizedTest
	@ValueSource(strings = { "pass", "Bearerpass", "bearer pass" })
	public void invalidNotBearerTokenRequest(String token) {
		try {
			Common.validateToken(token);
		} catch (InvalidTokenException e) {
			// passed
			return;
		}
		fail("No exception from invalid token");
	}

	@ParameterizedTest
	@ValueSource(strings = { "Bearer UnitTestToken" })
	public void validBearerTokenRequest(String token) {
		try {
			Common.validateToken(token);
		} catch (InvalidTokenException e) {
			fail("Exception from valid Bearer token");
		}
	}

	@Test
	public void checkInvalidTokenResponse() {
		log.info("Invalid token response test");

		ResponseEntity<String> response = Common.InvalidTokenResponse();
		assert 401 == response.getStatusCodeValue() : "code is not 401";

		JsonObject body = JsonParser.parseString(response.getBody()).getAsJsonObject();
		assert false == body.get("result").getAsBoolean() : "body doesn't have result == false";
		assert null != body.get("error") : "body doesn't have error message";
	}
}