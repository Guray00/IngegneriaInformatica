/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.valtriani.server;

import com.google.gson.Gson;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Contiene gli handler relativi ad eventi legati agli anime.
 * @author Lorenzo Valtriani (bobo)
 */
@Controller
@RequestMapping(path="/anime")
public class AnimeController {
    @Autowired
    private UtenteRepository utenteRepository; // iniettare l'interfaccia nel controller
    @Autowired
    private AnimeRepository animeRepository;   // iniettare l'inferfaccia nel controller
    
    /**
     * Ritorna tutti gli anime che si trovano nella lista dell'utente.
     * Se l'username passato come parametro GET non è associato ad alcun utente allora ritorna lancia un'eccezione.
     * @param user
     * @return 
     */
    @GetMapping(path="")
    @ResponseBody
    public Set<Anime> anime(@RequestParam String user){
        try {
            Utente u = utenteRepository.findByUsername(user);  
            if(u == null) throw new UtenteNonEsistenteException();
            return u.getAnime();
        } catch(UtenteNonEsistenteException e){
            throw new IllegalArgumentException("L'utente passato come parametro non si trova nel database - anime()");
        }      
    }
    
    /**
     * Ritorna tutti gli anime che contengono nel nome la sottostringa passata come parametro GET.
     * @param nomeAnime
     * @return 
     */
    @GetMapping(path="/cerca")
    @ResponseBody
    public Set<Anime> cercaAnime(@RequestParam String nomeAnime){
        Set<Anime> animes = animeRepository.findLikeNome(nomeAnime);  
        return animes;
    }
    
    /**
     * Cancella dalla lista dell'utente passato come parametro nella richiesta l'anime con l'id passato nella richiesta DELETE.Se l'utente o l'anime passati come parametri non esistono nel database, allora viene lanciata  una IllegalArgumenException.
     * @param user
     * @param idAnime 
     * @return  
     */
    @DeleteMapping(path="")
    @ResponseBody
    public String rimuoviAnime(@RequestParam String user, @RequestParam int idAnime){
        Gson gson = new Gson();
        // Ottenimento delle entità utente e anime
        Utente u = utenteRepository.findByUsername(user);
        Anime a = animeRepository.findById(idAnime);
        
        // viene lanciata una eccezzione perchè questo evento, è molto raro, dato che può capitare se c'è stata una modifica nella richiesta
        // magari da parte di un utente malintenzionato, perchè dal flusso normale dell'applicazione è impossibile mandare una richiesta con 
        // un username non valido o un id di un anime non valido.
        // lanciare una eccezione fa accorgere a chi gestisce il server che è successo qualcosa
        if(u == null || a == null) 
            throw new IllegalArgumentException("L'utente o l'anime passato come parametro non esistono nel db - rimuoviAnime()");
        if(u.anime.contains(a)){
            // cancellazione dal db
            utenteRepository.rimuoviAnime(u.getId(), a.getId()); 
            // rimozione dalle entità
            u.rimuoviAnime(a); 
            return gson.toJson(new CodiceRisposta(2000));
        } else 
            throw new IllegalArgumentException("L'anime passato come parametro non si trova nella lista dell'utente - rimuoviAnime()");
    }
    
    /**
     * Aggiunge l'anime di cui l'id è stato passato come parametro alla lista dell'utente il cui username è passato come paramtro della richiesta PUT.
     * Se l'utente o l'anime passati come parametri non esistono nel database, allora viene lanciata  una IllegalArgumenException.
     * Se si ha un inserimento corretto allora viene ritornato il codice "2001".
     * Se l'anime è già presente nella lista dell'utente viene ritornato il codice "2503".
     * @param user
     * @param idAnime
     * @return 
     */
    @PutMapping(path="")
    @ResponseBody
    public String aggiungiAnime(@RequestParam String user, @RequestParam Integer idAnime){
        Gson gson = new Gson();
        // Ottenimento delle entità utente e anime
        Utente u = utenteRepository.findByUsername(user);
        Anime a = animeRepository.findById(idAnime);
        
        // viene lanciata una eccezzione perchè questo evento, è molto raro, dato che può capitare se c'è stata una modifica nella richiesta
        // magari da parte di un utente malintenzionato, perchè dal flusso normale dell'applicazione è impossibile mandare una richiesta con 
        // un username non valido o un id di un anime non valido.
        // lanciare una eccezione fa accorgere a chi gestisce il server che è successo qualcosa
        if(u == null || a == null) 
            throw new IllegalArgumentException("L'utente o l'anime passato come parametro non esistono nel db - aggiungiAnime()");
        
        if(!u.anime.contains(a)){
            // se l'utente non ha già l'anime nella sua lista lo aggiunge nel db
            utenteRepository.inserisciAnime(u.getId(), a.getId()); 
            // e lo aggiunge nell'entità
            u.inserisciAnime(a);
            return gson.toJson(new CodiceRisposta(2001)); // inserimento corretto
        } else return gson.toJson(new CodiceRisposta(2503)); // Anime già inserito nella tua lista
    }
    
    
    
    
}
