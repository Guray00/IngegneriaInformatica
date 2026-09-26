/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package progetto.applicazione.manager;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.RepeatedTest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author sandro
 */
public class UserSessionTest {

	private static Logger log = LogManager.getLogger();

	public UserSessionTest() {
	}

	@BeforeAll
	public static void setUpClass() {
	}

	@AfterAll
	public static void tearDownClass() {
	}

	@BeforeEach
	public void setUp() {
	}

	@AfterEach
	public void tearDown() {
	}

	/**
	 * Test of setInstance method, of class UserSession.
	 */
	@RepeatedTest(value = 2)
	public void testSetInstance() {
		log.info("setInstance");

		String username = "testUser" + Math.random();
		String token = "asdfghjkl" + Math.random();

		UserSession result = UserSession.setInstance(username, token, new Date());

		if (result == null) {
			fail("instance not created");
		}

		assertEquals(username, result.getUsername());
		assertEquals(token, result.getToken());
	}
}
