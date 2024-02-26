/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.valtriani.server;

import com.google.gson.Gson;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Contiene gli handler relativi ad eventi legati agli utenti.
 * @author Lorenzo Valtriani (bobo)
 */
@Controller
@RequestMapping(path="/utente")
public class UtenteController {
    @Autowired
    private UtenteRepository utenteRepository; // iniettare l'interfaccia nel controller
    
    /**
     * Ritorna il codice corretto per notificare all'utente se la login è andata a buon fine o meno.
     * Se l'username che è stato inviato come parametro della richiesta GET, non è relativo ad alcun utente viene ritornato il codice "4004".
     * Se l'username è corretto ma la password no, allora viene inviato il codice "4003".
     * Se la login è andata a buon fine ritorna il codice "2000".
     * @param user
     * @param psw
     * @return 
     */
    @GetMapping(path="/login")
    @ResponseBody
    public String login(@RequestParam String user, @RequestParam String psw){
        Gson gson = new Gson();
        try {
            Utente u = utenteRepository.findByUsername(user);    
            if(u == null) throw new UtenteNonEsistenteException();
            String hash = u.getPassword();
            // Adesso bisogna confrontare la passoword in chiaro con l'hash ottenuto dal db
            // L'hash è stato fatto usando l'algoritmo bcrypt
            if(BCrypt.checkpw(psw, hash)) return gson.toJson(new CodiceRisposta(2000)); // Richiesta eseguita
            else return gson.toJson(new CodiceRisposta(4003)); // Errore di accesso, password non valida
        } catch(UtenteNonEsistenteException e){
            return gson.toJson(new CodiceRisposta(4004));      // Errore di accesso, username non valido
        }
    }
    
    /**
     * Ritorna il codice corretto per notificare all'utente sela registrazione è andata a buon fine oppure no.
     * Se l'username è già esistente ritorna il codice "4009".
     * Altrimenti la registrazione va a buon fine e ritorna il codice "2000".
     * @param u
     * @return 
     */
    @PutMapping(path="/registrazione")
    @ResponseBody
    public String registrazione(@RequestBody Utente u){
        Gson gson = new Gson();
        try {
            Utente ut = utenteRepository.findByUsername(u.getUsername());
            if(ut == null) throw new UtenteNonEsistenteException();
            return gson.toJson(new CodiceRisposta(4009));      // utente già esistente
        } catch(UtenteNonEsistenteException ex){
            // Se l'errore viene catturato significa che l'username non è già presente quindi okay
            u.setId(utenteRepository.nextId()); 
            u.setPassword(BCrypt.hashpw(u.getPassword(), BCrypt.gensalt()));
            Utente utente = new Utente(u);
            utenteRepository.save(utente);
            return gson.toJson(new CodiceRisposta(2000));   // corretta registrazione
        }
    }
}
