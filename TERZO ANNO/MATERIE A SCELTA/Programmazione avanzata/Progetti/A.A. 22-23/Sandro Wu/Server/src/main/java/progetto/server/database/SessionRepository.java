/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import java.util.Date;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import progetto.server.database.table.Session;

/**
 *
 * @author sandro
 */
public interface SessionRepository extends CrudRepository<Session, Integer> {

    Session findByToken(String token);

    /**
     * Get user id from valide token, not expired
     */
    @Query(nativeQuery = true, value = "SELECT s.user_id FROM session s WHERE s.token = ?1 and s.expire >= now()")
    Integer getUserId(String token);

    Session findByTokenAndExpireAfter(String token, Date now);
}
