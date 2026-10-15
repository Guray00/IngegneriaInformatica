/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import java.util.List;
import javax.persistence.Tuple;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import progetto.server.database.table.Resource;

/**
 *
 * @author sandro
 */
public interface ResourceRepository extends CrudRepository<Resource, Integer> {

    @Query(nativeQuery = true, //
            value = " SELECT r.id, r.name, r.status, r.plan, s.name as subscription, sv.name as service, sv.category "
                    +
                    " FROM resource r " +
                    " 	  INNER JOIN subscription s ON r.subscription_id = s.id " +
                    "     INNER JOIN service sv ON r.service_id = sv.id " +
                    " WHERE s.user_id = ?1 ")
    List<Tuple> getRes(int user_id);

}
