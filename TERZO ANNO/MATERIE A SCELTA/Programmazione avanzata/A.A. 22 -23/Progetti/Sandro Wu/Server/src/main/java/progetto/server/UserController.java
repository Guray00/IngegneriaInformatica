/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.persistence.Tuple;

import org.apache.commons.lang3.RandomStringUtils;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import progetto.server.beans.Response;
import progetto.server.database.ActionLogRepository;
import progetto.server.database.CostLogRepository;
import progetto.server.database.SessionRepository;
import progetto.server.database.UserRepository;
import progetto.server.database.table.ActionLog;
import progetto.server.database.table.Session;
import progetto.server.database.table.User;

/**
 *
 * @author sandro
 */
@Controller
@RequestMapping(path = "/user")
public class UserController {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private SessionRepository sessionRepository;

	@Autowired
	private ActionLogRepository actionlogRepository;

	@Autowired
	private CostLogRepository costlogRepository;

	static class LoginBody {
		public String user;
		public String pass;
	}

	/**
	 * @return { "result" : boolean, "token" : String | null }
	 */
	@PostMapping(path = "/login")
	public @ResponseBody ResponseEntity<String> login(@RequestBody LoginBody credentials) {

		JsonObject response = authenticate(credentials.user, credentials.pass);

		int code = 200;
		if (!response.get("result").getAsBoolean()) {
			code = 401;
		}
		return ResponseEntity.status(code).body(response.toString());
	}

	@GetMapping(path = "/activity")
	public @ResponseBody ResponseEntity<String> get_user_activity(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
		try {
			Integer userId = Common.validateToken(token);
			return getUserActivity(userId);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	@GetMapping(path = "/costs")
	public @ResponseBody ResponseEntity<String> get_user_costlogs(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token,
			@RequestParam long startTime,
			@RequestParam long endTime) {
		try {
			Integer userId = Common.validateToken(token);
			return getUserCostlogs(userId, new Date(startTime), new Date(endTime));
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	/* -------------------------------------------------------------------------- */
	/* --------------------------- Endpoints functions -------------------------- */
	/* -------------------------------------------------------------------------- */

	private ResponseEntity<String> getUserCostlogs(Integer userId, Date starDate, Date endDate) {

		List<Tuple> list = costlogRepository.findByUserId(userId, starDate, endDate);
		List<Map<String, Object>> map = Common.convertTupleList(list);

		Response res = new Response(true, map);

		Gson gson = new Gson();
		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);
	}

	private ResponseEntity<String> getUserActivity(Integer userId) {
		Gson gson = new Gson();

		Iterable<ActionLog> list = actionlogRepository.findByUserId(userId);

		Response res = new Response(true, list);

		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);
	}

	/**
	 * @return {"result" : boolean, "token" : String | null}
	 */
	private JsonObject authenticate(String name, String password) {
		JsonObject result = new JsonObject();

		User user = userRepository.findByName(name);
		boolean logged = false;
		String token = null;

		// if (true) {
		if (user != null && BCrypt.checkpw(password, user.getHash())) {

			token = RandomStringUtils.randomAlphanumeric(128);

			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			calendar.add(Calendar.HOUR_OF_DAY, 12);
			Date expireDate = calendar.getTime();

			// Session session = new Session(1, token, expireDate);
			Session session = new Session(user.getId(), token, expireDate);
			sessionRepository.save(session);

			logged = true;
			result.addProperty("expiration", expireDate.toInstant().toString());

		}

		result.addProperty("result", logged);
		result.addProperty("token", token);

		return result;
	}

}