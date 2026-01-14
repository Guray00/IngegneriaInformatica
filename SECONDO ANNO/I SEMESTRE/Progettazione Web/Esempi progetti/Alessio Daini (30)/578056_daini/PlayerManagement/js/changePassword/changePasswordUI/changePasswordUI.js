// riferimenti al DOM
const username = document.getElementById("usernameInput");
const question = document.getElementById("noBord");
const answer = document.getElementById("reactionInput");
const button = document.getElementById("sendQuestion");
const backButton = document.getElementById("goBack");
const form = document.querySelector("form");

// metodo che consente di gestire il DOM e gli elementi della pagina in dinamico
import{recoverQuestionAnswer} from "./recoverAnswer.js";
import {checkCorrectPassword} from "./checkCorrectPassword.js";

// -------------------------------------------FUNZIONI UI PRINCIPALI-------------------------------------------------

//listeners per la gestione della password
export function passwordManagement() {
    //listener applicato all'input
    username.addEventListener("change", ()=>{
        recoverQuestionAnswer(username,question);
    });

    //listener al click del bottone per mandare la domanda
    button.addEventListener("click", () =>{
        checkCorrectPassword(username,answer,form,button);
    });

    //listener per tornare indietro,andando a restituire l'ultima pagnia della cronologia con la pagina corrente
    backButton.addEventListener("click",()=>{
        window.location.replace("login.html");
    });

    // ripulisce l’errore quando l’utente digita di nuovo
    answer.addEventListener("input", () => {
        answer.setCustomValidity("");
    });
}

