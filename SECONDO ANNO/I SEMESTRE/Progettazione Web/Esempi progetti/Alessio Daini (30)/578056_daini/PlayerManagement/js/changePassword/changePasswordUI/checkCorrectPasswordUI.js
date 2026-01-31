import { createPassword,createIToggle,createNewButton } from "./createNewObjects.js";

// funzione di utilità per checkCorrectPassword()
export function createChangePasswordUI(form,username,button) {
    
    //rimuovo il bottone
    button.remove();
    //creo un nuovo div
    createDiv(form,username);

}

// funzione di utilità per createChangePasswordUI.js
function createDiv(form,username){
    //creo un div per allineare orizzontalmente il nuovo elemento della pagina da aggiungere
    const div = document.createElement("div");
    div.classList.add("HorizontalAlignment");
    //label per il cambio di passaggio
    const label = document.createElement("label");
    label.textContent = "Cambia Password:";
    div.appendChild(label);
    //div per inserire input e il bottone con immagine per poter vedere la password che stiamo scegliendo
    const divToggle = document.createElement("div");
    divToggle.classList.add("input-with-icon");

    //crezione oggetto password
    const password = createPassword(divToggle);
    
    //elemento per il toggle
    const i = createIToggle(password);

    divToggle.appendChild(i);    

    div.appendChild(divToggle);

    form.appendChild(div);
    
    // creo il nuovo bottone
    const newButton = createNewButton(username,password,form);

    //inserisco il bottone nel form
    form.appendChild(newButton);
}

