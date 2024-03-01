package progetto.server;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.persistence.Tuple;
import javax.persistence.TupleElement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;

import progetto.server.beans.Response;
import progetto.server.database.SessionRepository;

@Component
public class Common {

    private static SessionRepository sessionRepository;

    @Autowired
    public void setSessionRepository(SessionRepository sessionRepository) {
        Common.sessionRepository = sessionRepository;
    }

    public static ResponseEntity<String> InvalidTokenResponse() {
        Response res = new Response("Invalid token or session expired");
        return ResponseEntity.status(401).body(new Gson().toJson(res));
    }

    public static Integer validateToken(String token)
            throws InvalidTokenException {

        String[] l = token.split("Bearer ");
        if (l.length < 2) {
            throw new InvalidTokenException();
        }

        token = token.split("Bearer ")[1];
        Integer user_id = sessionRepository.getUserId(token);

        if (user_id == null) {
            throw new InvalidTokenException();
        }
        return user_id;
    }

    /**
     * convert to [{columNames: values} ...]
     */
    public static List<Map<String, Object>> convertTupleList(List<Tuple> list) {
        return list.stream().map(
                tuple -> {
                    HashMap<String, Object> map = new HashMap<>();
                    for (TupleElement<?> keyAlias : tuple.getElements()) {
                        String key = keyAlias.getAlias();
                        map.put(key, tuple.get(key));
                    }
                    return map;
                })
                .collect(Collectors.toList());
    }
}
