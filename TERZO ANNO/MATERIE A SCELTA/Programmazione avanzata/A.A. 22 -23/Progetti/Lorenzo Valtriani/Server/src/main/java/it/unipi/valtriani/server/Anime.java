package it.unipi.valtriani.server;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 * Classe che rappresenta la tabella Anime del database.
 * Lato target della relazione.
 * @author Lorenzo Valtriani (bobo)
 */
@Entity
@Table(name="Anime", schema="Anime")
public class Anime {
    
    @Id
    private Integer id;
    
    @Column(name="nome")
    private String nome;
    @Column(name="genere")
    private String genere;
    @Column(name="episodi")
    private Integer episodi;
    @Column(name="durata")
    private String durata;
    @Column(name="trailer")
    private String trailer;
    
    // la relazione tra la tabella anime e utente è many to many.
    // più utenti possono avere nella listra lo stesso anime, più anime possono essere nella lista del solito utente
    @ManyToMany(mappedBy = "anime", cascade = CascadeType.ALL)
    Set<Utente> utenti;
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getGenere() {
        return genere;
    }

    public void setGenere(String genere) {
        this.genere = genere;
    }

    public Integer getEpisodi() {
        return episodi;
    }

    public void setEpisodi(Integer episodi) {
        this.episodi = episodi;
    }

    public String getDurata() {
        return durata;
    }

    public void setDurata(String durata) {
        this.durata = durata;
    }

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }
    
    // annonazione che dichiara il fatto che Set<Utente> vengano serializzati
    // inserita la annotazione Managed perchè Utente è il proprietario della relazione.
    @JsonManagedReference
    public Set<Utente> getUtentiAnime(){
        return utenti;
    }
        
    public Anime() {
    }

    public Anime(Integer id, String nome, String genere, Integer episodi, String durata, String trailer) {
        this.id = id;
        this.nome = nome;
        this.genere = genere;
        this.episodi = episodi;
        this.durata = durata;
        this.trailer = trailer;
    }
    
    
}
