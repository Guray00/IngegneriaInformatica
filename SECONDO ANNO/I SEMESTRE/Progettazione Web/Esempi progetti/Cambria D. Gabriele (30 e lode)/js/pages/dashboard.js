"use strict";

import {showInventory, showMenu, showShop, closeModuleEvent, openBoxSelected, moduleListener, showMessage, errorHandler, openBox} from "./../utils/methods.js";

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("inventory-btn").addEventListener("click", () => {showInventory()});
    document.getElementById("shop-btn").addEventListener("click", () => {showShop()});
    document.getElementById("menu").addEventListener("click", () => {showMenu()});
    document.addEventListener("keypress", handleKeyPress);

    document.querySelectorAll(".character-item").forEach((PG) => {
        PG.addEventListener("click", (e) => {
            openCharacter(e.currentTarget.getAttribute("id"));
        })
    })


    let addBtn = document.getElementById("add-character");
    if(addBtn !== null)
        addBtn.addEventListener("click", addNewCharacter);

    if(message){
        showMessage(message);
    }
    
    if(errorMessage){
        errorHandler(errorMessage);
    }
});

/**
 * Funzione per la gestione dei comandi da tastiera.
 * Permette di aprire o chiudere moduli specifici o interagire con una box.
 * @param {Event} e Evento generato dalla pressione di un tasto
 */
function handleKeyPress(e){
    const keyCode = e.code.toUpperCase();
    switch(keyCode){
        case "KEYI":
            (moduleListener === null)?
                showInventory() :
                closeModuleEvent(null, "inventoryModule", true);
            break;
        case "KEYN":
            (moduleListener === null)?
                showShop() :
                closeModuleEvent(null, "shopModule", true);
            break;
        case "SPACE":
            if(openBoxSelected) openBox();
            break;
    }
}

/**
 * Effettua un redirect verso la pagina di creazione nuovo personaggio
 */
function addNewCharacter(){
    window.location.href = "./creazionePersonaggio.php";
}

/**
 * Effettua una richiesta POST per aprire la pagina di gestione del personaggio.
 * @param {string} characterName Nome del personaggio selezionato.
 */
function openCharacter(characterName){
    const formData = new FormData();
    formData.append("pg", characterName);

    document.body.classList.add("caricamento");
    fetch("./gestisciPersonaggio.php", {
        method: "POST",
        body: formData,
    })
    .then(response => {
        document.body.classList.remove("caricamento");
        if (response.ok){
            if (response.redirected){
                window.location.href = response.url;
            } 
            else {
                return response.text();
            }
        } else {
            throw new Error(`Errore HTTP: ${response.status}`);
        }
    })
    .then(data => {
        if(data){
            throw {
                message: "Errore nella richiesta al server",
                errorcode: 500
            };
        }
    })
    .catch(error => {
        errorHandler(error);
    });
    
}