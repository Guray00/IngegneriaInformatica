/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import java.util.Date;
import java.util.List;

import javax.persistence.Tuple;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import progetto.server.database.table.CostLog;

/**
 *
 * @author sandro
 */
public interface CostLogRepository extends CrudRepository<CostLog, Integer> {

    @Query(nativeQuery = true, //
            value = " SELECT c.*, r.name as resource_name" +
                    " FROM cost_log c " +
                    " 	  INNER JOIN resource r ON r.id = c.resource_id " +
                    "     INNER JOIN subscription s ON s.id = r.subscription_id " +
                    " WHERE s.user_id = ?1 " +
                    "       AND c.start_date >= ?2 " +
                    "       AND c.end_date <= ?3 ")
    List<Tuple> findByUserId(Integer userId, Date starDate, Date endDate);

}
