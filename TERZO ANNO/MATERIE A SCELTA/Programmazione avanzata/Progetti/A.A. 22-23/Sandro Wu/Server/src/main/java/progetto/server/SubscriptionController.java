package progetto.server;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import progetto.server.beans.Response;
import progetto.server.database.ActionLogRepository;
import progetto.server.database.SubscriptionRepository;
import progetto.server.database.table.ActionLog;
import progetto.server.database.table.Status;
import progetto.server.database.table.Subscription;

@Controller
@RequestMapping(path = "/subscription")
public class SubscriptionController {

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private ActionLogRepository actionlogRepository;

    /**
     * @return { "result" : boolean, "data" : Subscription[] || "error" : string }
     */
    @GetMapping(path = "/user")
    public @ResponseBody ResponseEntity<String> get_user_subscrip(
            @RequestHeader(HttpHeaders.AUTHORIZATION) String token) {
        try {
            Integer userId = Common.validateToken(token);
            return getUserSubscriptions(userId);
        } catch (InvalidTokenException e) {
            return Common.InvalidTokenResponse();
        }
    }

    static class SubscriptionBody {
        public String name;
        public Integer service_id;
        public Integer subscription_id;
        public String plan;
    }

    // @PostMapping(path = "/create")
    // public @ResponseBody ResponseEntity<String> create_user_subscription(
    // @RequestHeader(HttpHeaders.AUTHORIZATION) String token,
    // @RequestBody SubscriptionBody subscriptionBody) {
    // try {
    // Integer userId = Common.validateToken(token);
    // return createSubscription(userId, subscriptionBody);
    // } catch (InvalidTokenException e) {
    // return Common.InvalidTokenResponse();
    // }
    // }

    // @DeleteMapping(path = "")
    // public @ResponseBody ResponseEntity<String> delete_subscription(
    // @RequestHeader(HttpHeaders.AUTHORIZATION) String token,
    // @RequestParam Integer id) {
    // try {
    // Integer userId = Common.validateToken(token);
    // return deleteSubscription(userId, id);
    // } catch (InvalidTokenException e) {
    // return Common.InvalidTokenResponse();
    // }
    // }

    /**
     * @return { "result" : boolean, + "error" : string }
     */
    @PostMapping(path = "/stop")
    public @ResponseBody ResponseEntity<String> stop_subscription(
            @RequestHeader(HttpHeaders.AUTHORIZATION) String token,
            @RequestParam Integer id) {
        try {
            Integer userId = Common.validateToken(token);
            return stopSubscription(userId, id);
        } catch (InvalidTokenException e) {
            return Common.InvalidTokenResponse();
        }
    }

    /**
     * @return { "result" : boolean, + "error" : string }
     */
    @PostMapping(path = "/activate")
    public @ResponseBody ResponseEntity<String> activate_subscription(
            @RequestHeader(HttpHeaders.AUTHORIZATION) String token,
            @RequestParam Integer id) {
        try {
            Integer userId = Common.validateToken(token);
            return activateSubscription(userId, id);
        } catch (InvalidTokenException e) {
            return Common.InvalidTokenResponse();
        }
    }

    /* -------------------------------------------------------------------------- */
    /* --------------------------- Endpoints functions -------------------------- */
    /* -------------------------------------------------------------------------- */

    private ResponseEntity<String> getUserSubscriptions(Integer userId) {
        Gson gson = new Gson();

        Iterable<Subscription> list = subscriptionRepository.findByUserId(userId);

        Response res = new Response(true, list);

        String jsonString = gson.toJson(res);
        return ResponseEntity.status(200).body(jsonString);
    }

    private ResponseEntity<String> activateSubscription(Integer user_id, Integer subscrp_id) {
        Gson gson = new Gson();
        Map<String, Object> res = new HashMap<>();

        Optional<Subscription> sub_ = subscriptionRepository.findById(subscrp_id);
        Subscription sub = sub_.get();
        if (sub_.isPresent() && sub.getUserId() == user_id && !sub.getStatus().equals(Status.Active.toString())) {
            sub.setStatus(Status.Active.toString());
            subscriptionRepository.save(sub);
            actionlogRepository.save(new ActionLog(new Date(), user_id,
                    String.format("[41900] Activated subscription - %s", sub.getName())));

            res.put("status", sub.getStatus());
            res.put("result", true);
        } else {
            res.put("result", false);
        }

        String jsonString = gson.toJson(res);
        return ResponseEntity.status(200).body(jsonString);
    }

    private ResponseEntity<String> stopSubscription(Integer user_id, Integer subscrp_id) {
        Gson gson = new Gson();
        Map<String, Object> res = new HashMap<>();

        Optional<Subscription> sub_ = subscriptionRepository.findById(subscrp_id);
        Subscription sub = sub_.get();
        if (sub_.isPresent() && sub.getUserId() == user_id && !sub.getStatus().equals(Status.Stopped.toString())) {
            sub.setStatus(Status.Stopped.toString());
            subscriptionRepository.save(sub);

            actionlogRepository.save(new ActionLog(new Date(), user_id,
                    String.format("[40800] Stopped subscription - %s", sub.getName())));

            res.put("status", sub.getStatus());
            res.put("result", true);
        } else {
            res.put("result", false);
        }

        String jsonString = gson.toJson(res);
        return ResponseEntity.status(200).body(jsonString);
    }

    // private ResponseEntity<String> deleteSubscription(Integer user_id, Integer
    // subscrp_id) {
    // Gson gson = new Gson();
    // Map<String, Object> res = new HashMap<>();

    // Optional<Subscription> sub_ = subscriptionRepository.findById(subscrp_id);
    // if (sub_.isPresent()) {
    // Subscription sub = sub_.get();
    // if (sub.getUserId() == user_id) {
    // subscriptionRepository.delete(sub);
    // // TODO add log
    // }
    // }

    // res.put("result", true);
    // String jsonString = gson.toJson(res);
    // return ResponseEntity.status(200).body(jsonString);

    // }

    // private ResponseEntity<String> createSubscription(Integer userId,
    // SubscriptionBody r) {

    // Gson gson = new Gson();

    // Subscription newSubscription = new Subscription(userId, r.name,
    // Status.Active.toString());
    // subscriptionRepository.save(newSubscription);

    // // TODO log

    // Response res = new Response(true, newSubscription);

    // String jsonString = gson.toJson(res);
    // return ResponseEntity.status(200).body(jsonString);
    // }

}
