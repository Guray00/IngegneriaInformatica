/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package it.unipi.valtriani.server;

import com.google.gson.Gson;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Unit test per la classe UtenteController.
 * @author Lorenzo Valtriani (bobo)
 */
@SpringBootTest
public class UtenteControllerTest {
    
    @Autowired
    private UtenteController uc;
    
    /**
     * Test of login method, of class UtenteController.
     * Testa quando le credenziali sono giuste
     */
    @Test
    public void testLogin_right_credentials() {
        Gson gson = new Gson();
        System.out.println("test login corretto");
        String user = "bobo";
        String psw = "Onepiece1*";
        String expResult = gson.toJson(new CodiceRisposta(2000));
        String result = uc.login(user, psw);
        assert expResult.equals(result);
    }

    /**
     * Test of login method, of class UtenteController.
     * Testa quando le credenziali sono sbagliate
     */
    @Test
    public void testLogin_wrong_credentials() {
        Gson gson = new Gson();
        System.out.println("test login sbagliato");
        String user = "bobo";
        String psw = "PasswordSbagliata";
        String expResult = gson.toJson(new CodiceRisposta(4003));
        String result = uc.login(user, psw);
        assert expResult.equals(result);
    }
    
    /**
     * Test of login method, of class UtenteController.
     * Testa l'username che non esiste
     */
    @Test
    public void testLogin_username_not_exists() {
        Gson gson = new Gson();
        System.out.println("test login username non esistente");
        String user = "UsernameSbagliato";
        String psw = "Onepiece1*";
        String expResult = gson.toJson(new CodiceRisposta(4004));
        String result = uc.login(user, psw);
        assert expResult.equals(result);
    }
    
    /**
     * Test of registrazione method, of class UtenteController.
     * Testa la registrazione di un utente con username già inserito
     */
    @Test
    public void testRegistrazione_username_already_exists() {
        Gson gson = new Gson();
        System.out.println("test registrazione username già presente");
        Utente u = new Utente("bobo", "password");
        String expResult = gson.toJson(new CodiceRisposta(4009));
        String result = uc.registrazione(u);
        assert expResult.equals(result);
    }
    
    /**
     * Test of registrazione method, of class UtenteController.
     * Testa la registrazione di un utente con username nuovo.
     */
    @Test
    public void testRegistrazione_username_not_exists() {
        Gson gson = new Gson();
        System.out.println("test registrazione username nuovo");
        Utente u = new Utente(UUID.randomUUID().toString(), "password");
        String expResult = gson.toJson(new CodiceRisposta(2000));
        String result = uc.registrazione(u);
        assert expResult.equals(result);
    }
    
}
