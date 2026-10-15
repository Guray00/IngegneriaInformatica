package progetto.server;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import progetto.server.beans.Response;
import progetto.server.database.PlanRepository;
import progetto.server.database.ServiceRepository;
import progetto.server.database.table.Plan;
import progetto.server.database.table.Service;

@Controller
@RequestMapping(path = "/service")
public class ServiceController {

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private PlanRepository planRepository;

    /**
     * @return { "result" : boolean, "data" : Service[] || "error" : string }
     */
    @GetMapping(path = "/all")
    public @ResponseBody ResponseEntity<String> get_allservices() {
        return getAllServices();
    }

    /**
     * @return { "result" : boolean, "data" : Plan[] || "error" : string }
     */
    @GetMapping(path = "/plans")
    public @ResponseBody ResponseEntity<String> get_service_plans(
            @RequestParam Integer id) {
        return getServicePlans(id);
    }

    /* -------------------------------------------------------------------------- */
    /* --------------------------- Endpoints functions -------------------------- */
    /* -------------------------------------------------------------------------- */

    private ResponseEntity<String> getServicePlans(Integer id) {
        Gson gson = new Gson();

        Iterable<Plan> list = planRepository.getServicePlans(id);

        Response res = new Response(true, list);

        String jsonString = gson.toJson(res);
        return ResponseEntity.status(200).body(jsonString);
    }

    private ResponseEntity<String> getAllServices() {

        Gson gson = new Gson();

        Iterable<Service> list = serviceRepository.findAll();

        Response res = new Response(true, list);

        String jsonString = gson.toJson(res);
        return ResponseEntity.status(200).body(jsonString);
    }
}
