/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.valtriani.server;

/**
 * Eccezione UtenteNonEsistente
 * @author Lorenzo Valtriani (bobo)
 */
public class UtenteNonEsistenteException extends Exception {

    public UtenteNonEsistenteException() {
    }

    public UtenteNonEsistenteException(String message) {
        super(message);
    }
    
}
