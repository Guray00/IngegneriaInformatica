/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import org.springframework.data.repository.CrudRepository;

import progetto.server.database.table.ActionLog;

/**
 *
 * @author sandro
 */
public interface ActionLogRepository extends CrudRepository<ActionLog, Integer> {

    Iterable<ActionLog> findByUserId(Integer userId);

}
