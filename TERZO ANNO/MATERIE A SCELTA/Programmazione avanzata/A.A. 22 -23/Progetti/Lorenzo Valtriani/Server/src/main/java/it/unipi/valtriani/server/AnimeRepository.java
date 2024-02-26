/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package it.unipi.valtriani.server;

import java.util.Set;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

/**
 * Interfaccia che estende la classe e fornisce funzioni di base per l'estrazione/memorizzazione di dati col db
 * @author Lorenzo Valtriani (bobo)
 */
public interface AnimeRepository extends CrudRepository<Anime, Long> {
    
    /**
     * Trova l'anime dal suo id.
     * @param id
     * @return Utente
     */
    public Anime findById(Integer id);
    
    /**
     * Restituisce tutti gli anime che hanno nel proprio nome una sottostringa di ciò che l'utente  ha cercato
     * @param nomeAnime
     * @return 
     */
    @Query(value="SELECT * FROM Anime WHERE nome LIKE CONCAT('%',:nomeAnime,'%')", nativeQuery = true)
    public Set<Anime> findLikeNome(String nomeAnime);
}
