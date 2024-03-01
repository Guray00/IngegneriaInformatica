/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server;

import com.google.gson.Gson;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.persistence.Tuple;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import progetto.server.beans.Response;
import progetto.server.database.ActionLogRepository;
import progetto.server.database.ResourceRepository;
import progetto.server.database.ServiceRepository;
import progetto.server.database.SubscriptionRepository;
import progetto.server.database.table.ActionLog;
import progetto.server.database.table.Resource;
import progetto.server.database.table.Service;
import progetto.server.database.table.Status;
import progetto.server.database.table.Subscription;

/**
 *
 * @author sandro
 */
@Controller
@RequestMapping(path = "/resource")
public class ResourceController {

	@Autowired
	private SubscriptionRepository subscriptionRepository;

	@Autowired
	private ResourceRepository resourceRepository;

	@Autowired
	private ServiceRepository serviceRepository;

	@Autowired
	private ActionLogRepository actionlogRepository;

	/**
	 * @return { "result" : boolean, "data" : ResourceView[] || "error" : string }
	 */
	@GetMapping(path = "/user")
	public @ResponseBody ResponseEntity<String> get_user_resources(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
		try {
			Integer userId = Common.validateToken(token);
			return getUserResources(userId);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	static class ResourceBody {
		public String name;
		public Integer service_id;
		public Integer subscription_id;
		public String plan;
	}

	/**
	 * @return { "result" : boolean, + "error" : string }
	 */
	@PostMapping(path = "/create")
	public @ResponseBody ResponseEntity<String> create_user_resource(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token,
			@RequestBody ResourceBody resourceBody) {
		try {
			Integer userId = Common.validateToken(token);
			return createResources(userId, resourceBody);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	/**
	 * @return { "result" : boolean, + "error" : string }
	 */
	@DeleteMapping(path = "")
	public @ResponseBody ResponseEntity<String> delete_resource(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token,
			@RequestParam Integer id) {
		try {
			Integer userId = Common.validateToken(token);
			return deleteResource(userId, id);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	/**
	 * @return { "result" : boolean, + "error" : string }
	 */
	@PostMapping(path = "/stop")
	public @ResponseBody ResponseEntity<String> stop_resource(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token,
			@RequestParam Integer id) {
		try {
			Integer userId = Common.validateToken(token);
			return stopResource(userId, id);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	/**
	 * @return { "result" : boolean, + "error" : string }
	 */
	@PostMapping(path = "/activate")
	public @ResponseBody ResponseEntity<String> activate_resource(
			@RequestHeader(HttpHeaders.AUTHORIZATION) String token,
			@RequestParam Integer id) {
		try {
			Integer userId = Common.validateToken(token);
			return activateResource(userId, id);
		} catch (InvalidTokenException e) {
			return Common.InvalidTokenResponse();
		}
	}

	/* -------------------------------------------------------------------------- */
	/* --------------------------- Endpoints functions -------------------------- */
	/* -------------------------------------------------------------------------- */

	private ResponseEntity<String> activateResource(Integer user_id, Integer resource_id) {
		Gson gson = new Gson();
		Map<String, Object> res = new HashMap<>();

		// Check if resource is owned by the user
		Optional<Resource> resource_ = resourceRepository.findById(resource_id);
		if (resource_.isPresent()) {
			Resource resource = resource_.get();
			Subscription sub = subscriptionRepository.findByIdAndUserId(resource.getSubscriptionId(), user_id);

			if (sub != null && !resource.getStatus().equals(Status.Active.toString())) {
				resource.setStatus(Status.Active.toString());
				resourceRepository.save(resource);

				Optional<Service> service = serviceRepository.findById(resource.getServiceId());

				actionlogRepository.save(new ActionLog(new Date(), user_id,
						String.format("[30110] Activated resource - %s - %s", service.get().getName(),
								resource.getName())));

			}
			res.put("status", resource.getStatus());
		}

		// Response resp = new Response(true, "{\"data\": status}");

		res.put("result", true);
		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);
	}

	private ResponseEntity<String> stopResource(Integer user_id, Integer resource_id) {
		Gson gson = new Gson();
		Map<String, Object> res = new HashMap<>();

		// Check if resource is owned by the user
		Optional<Resource> resource_ = resourceRepository.findById(resource_id);
		if (resource_.isPresent()) {
			Resource resource = resource_.get();
			Subscription sub = subscriptionRepository.findByIdAndUserId(resource.getSubscriptionId(), user_id);

			if (sub != null && !resource.getStatus().equals(Status.Stopped.toString())) {
				resource.setStatus(Status.Stopped.toString());
				resourceRepository.save(resource);

				Optional<Service> service = serviceRepository.findById(resource.getServiceId());

				actionlogRepository.save(new ActionLog(new Date(), user_id,
						String.format("[30102] Stopped resource - %s - %s", service.get().getName(),
								resource.getName())));
			}

			res.put("status", resource.getStatus());
		}

		res.put("result", true);
		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);
	}

	private ResponseEntity<String> deleteResource(Integer user_id, Integer resource_id) {
		Gson gson = new Gson();
		Map<String, Object> res = new HashMap<>();

		// Check if resource is owned by the user
		Optional<Resource> resource_ = resourceRepository.findById(resource_id);
		if (resource_.isPresent()) {
			Resource resource = resource_.get();
			Subscription sub = subscriptionRepository.findByIdAndUserId(resource.getSubscriptionId(), user_id);

			if (sub != null) {
				resourceRepository.delete(resource);
				// Shoul move in another table to not lose information

				Optional<Service> service = serviceRepository.findById(resource.getServiceId());

				actionlogRepository.save(new ActionLog(new Date(), user_id,
						String.format("[41900] Deleted resource - %s - %s", service.get().getName(),
								resource.getName())));
			}
		}

		res.put("result", true);
		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);

	}

	private ResponseEntity<String> getUserResources(Integer user_id) {
		Gson gson = new Gson();

		List<Tuple> list = resourceRepository.getRes(user_id);
		List<Map<String, Object>> map = Common.convertTupleList(list);

		Response res = new Response(true, map);

		String jsonString = gson.toJson(res);
		return ResponseEntity.status(200).body(jsonString);

	}

	private ResponseEntity<String> createResources(Integer userId, ResourceBody r) {

		Gson gson = new Gson();
		Response res;

		// check if user and subscription corresponds
		Optional<Subscription> sub = subscriptionRepository.findById(r.subscription_id);
		if (sub.isPresent() && sub.get().getUserId() == userId) {

			Resource newResource = new Resource(
					r.name,
					r.subscription_id,
					r.service_id,
					Status.Active.toString(),
					r.plan);
			resourceRepository.save(newResource);

			Optional<Service> service = serviceRepository.findById(r.service_id);

			actionlogRepository.save(new ActionLog(new Date(), userId,
					String.format("[12080] Created resource - %s - %s", service.get().getName(), r.name)));

		} else {
			res = new Response("Inconsistent request body data");
			return ResponseEntity.status(400).body(gson.toJson(res));
		}

		res = new Response(true, null);
		return ResponseEntity.status(200).body(gson.toJson(res));
	}

}
