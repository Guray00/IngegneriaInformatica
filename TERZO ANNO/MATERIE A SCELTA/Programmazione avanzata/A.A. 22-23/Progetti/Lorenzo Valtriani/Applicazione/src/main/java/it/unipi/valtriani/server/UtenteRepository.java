/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package it.unipi.valtriani.server;

import javax.transaction.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

/**
 * Interfaccia che estende la classe e fornisce funzioni di base per l'estrazione/memorizzazione di dati col db
 * @author Lorenzo Valtriani (bobo)
 */
public interface UtenteRepository extends CrudRepository<Utente, Integer> {
    
    /**
     * Trova l'Utente dal suo username.
     * @param user
     * @return Utente
     */
    public Utente findByUsername(String user);
    
    /**
     * Id del prossimo utente da inserire nel database.
     * @return 
     */
    @Query(value= "SELECT MAX(id)+1 FROM Utente", nativeQuery = true)
    public int nextId();
    
    /**
     * Cancella sul database l'anime con id passato da parametro nella lista dell'utente con id passato come parametro.
     * @param idUtente
     * @param idAnime 
     */
    @Transactional
    @Modifying
    @Query(value = "DELETE FROM listaanime LA WHERE LA.idutente = :idUtente AND LA.idanime = :idAnime", nativeQuery = true)
    public void rimuoviAnime(Integer idUtente, Integer idAnime);
    
    /**
     * Inserisci un nuovo utente nel database.
     * @param idUtente
     * @param idAnime 
     */
    @Transactional
    @Modifying
    @Query(value = "INSERT INTO listaanime VALUES(:idUtente, :idAnime)", nativeQuery = true)
    public void inserisciAnime(Integer idUtente, Integer idAnime);
}
