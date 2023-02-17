/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import progetto.server.database.table.Plan;

/**
 *
 * @author sandro
 */
public interface PlanRepository extends CrudRepository<Plan, Integer> {

    /**
     * Get user id from valide token, not expired
     */
    // @Query(nativeQuery = true, value = "SELECT s.user_id FROM session s WHERE
    // s.token = ?1 and s.expire >= now()")
    @Query(nativeQuery = true, value = "SELECT p.* FROM plan p WHERE p.id IN (SELECT plan_id FROM service_plan WHERE service_id = ?1)")
    Iterable<Plan> getServicePlans(Integer service_id);

}
