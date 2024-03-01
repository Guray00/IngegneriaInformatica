/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.valtriani.server;

import com.fasterxml.jackson.annotation.JsonBackReference;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

/**
 * Classe che rappresenta la tabella Utente del database.
 * Lato proprietario della relazione.
 * @author Lorenzo Valtriani (bobo)
 */
@Entity
@Table(name="Utente", schema="Utente")
public class Utente {
    
    @Id
    private Integer id;
    @Column(name="username")
    private String username;
    @Column(name="password")
    private String password;
    
    // forniamo il nome della tabella di join del database e delle chiavi esterne
    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(
        name = "listaanime", 
        joinColumns = @JoinColumn(name = "idutente"), 
        inverseJoinColumns = @JoinColumn(name = "idanime"))
    Set<Anime> anime;
    
    public Utente(Integer id, String username, String password) {
        this.id = id;
        this.username = username;
        this.password = password;
    }
    
    public Utente(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    public Utente(Utente u){
        this.id = u.id;
        this.username = u.username;
        this.password = u.password;
        
    }
    
    public Utente() {
        
    }
  
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    // annonazione che dichiara il fatto che Set<Anime> vengano serializzati.
    // Uso Back perchè Anime è il target della relazione.
    @JsonBackReference
    public Set<Anime> getAnime(){
        return anime;
    }
    
    public void rimuoviAnime(Anime a){
        this.anime.remove(a);
        a.getUtentiAnime().remove(this);
    }
    
    public void inserisciAnime(Anime a){
        this.anime.add(a);
        a.getUtentiAnime().add(this);
    }
}
