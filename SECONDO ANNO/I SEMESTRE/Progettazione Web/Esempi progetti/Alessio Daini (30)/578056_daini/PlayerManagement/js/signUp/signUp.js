import {sendRequestCorrectInsert} from "./fetch.js";
import{toggleEvent} from "./toggle.js";
import { Config } from "./Config.js";

function checkEqualPassword() {
  if (Config.inputPassword1.value !== Config.inputPassword2.value) {
      Config.inputPassword2.setCustomValidity("Le password non coincidono");
      return false;
  } else {
    Config.inputPassword2.setCustomValidity(""); // resetta
    return true;
  }
}

  // Quando l'utente inizia a scrivere, svuota la validità
Config.username.addEventListener("input", () => {
  Config.username.setCustomValidity("");
});

Config.inputPassword1.addEventListener("input", () => {
  Config.inputPassword1.setCustomValidity("");
});

Config.inputPassword2.addEventListener("input", () => {
  Config.inputPassword2.setCustomValidity("");
});

async function checkInsert() {

  Config.inputPassword2.setCustomValidity("");

  if (!Config.form.checkValidity()) {
    Config.form.reportValidity();
    return;
  }

  if (!checkEqualPassword()) {
    Config.inputPassword2.reportValidity();
    return;
  }
  
  Config.username.setCustomValidity(""); // Assicurati di resettare anche questo

  const message = await sendRequestCorrectInsert();

  // non riesco a far apparire il messaggio di errore
  if (message === "username già esistente; per cortesia, provare con un altro") {

    // 1. Imposta errore
    Config.username.setCustomValidity("Questo username è già in uso. Scegline un altro.");
  
    // 2. Forza focus
    Config.username.focus();
  
    // 3. Forza validazione nel frame successivo
    // per maggiori informazioni:
    // da https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame?utm_source=chatgpt.com :

    //essendo il form già corretto, bisogna forzare il report validity al prossimo repaint della pagina
    //tale repaint accade solitamente ogni 60 cicli/frame per secondo
    requestAnimationFrame(() => {
      Config.username.reportValidity(); 
    });
  
    return;
  }

}

Config.button.addEventListener("click", async(event)=>{
    event.preventDefault();
    await checkInsert();
  });

Config.historyButton.addEventListener("click",() =>{
  window.location.replace("login.html");
});

toggleEvent();
