/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.server.database;

import org.springframework.data.repository.CrudRepository;
import progetto.server.database.table.User;

/**
 *
 * @author sandro
 */
public interface UserRepository extends CrudRepository<User, Integer> {

	User findByName(String name);

}
