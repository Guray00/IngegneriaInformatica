"use strict";

import { Timer } from "./definitions.js";


export const patterns = {
    USERNAME : "^[a-zA-Z][a-zA-Z0-9_.]{2,9}$",
    //? source: https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    PASSWORD: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,15}$"
    //? endsource
};

/**
 * Costante di tempo che identifica quando applicare lo stile di messaggio importante 
 * @function `showMessage()`
 */
export const IMPORTANT_MESSAGE = 4000;

/**
 * Costante di tempo che identifica quando applicare lo stile di messaggio dal gioco 
 * @function `showMessage()`
 */
export const GAME_MESSAGE = 6000;

/**
 * Indica la funzione di listener per rimuovere i moduli in sovraimpressione
 */
export let moduleListener = null;

/**
 * Contiene gli item restituiti dalla box aperta
 */
let openedItems = [];

/**
 * Indica quale item è stato selezionato dall'utente per venire mostrato nel dettaglio
 */
let shownItem = null;

/* *
 * Indica se nel dettaglio è presente una box, necessaria per poterla aprire da tastiera
 */
export let openBoxSelected = false;

/**
 * Timer del negozio
 */
let shopTimer = null;

/**
 * Contiene l'id del modulo aperto in un determinato momento
 */
let currentlyOpened = null;


// *** Funzioni di supporto alla creazione/gestione di elementi HTML ***/

/**
 * Crea un elemento HTML con le proprietà specificate.
 * @param {String} type Il tipo dell'elemento (es. "div", "span").
 * @param {String} className La classe CSS da assegnare all'elemento. [Default `null`]
 * @param {String} id L'id da assegnare all'elemento. [Default `null`]
 * @param {String} innerText Il testo da inserire nell'elemento. [Default `null`]
 * @returns {HTMLElement} L'elemento creato.
 */
export function createHTMLElement(type, className = null, id = null, innerText = null){
    const el = document.createElement(type);
    if(className)
        el.classList.add(className);
    if(id)
        el.id = id;
    if(innerText)
        el.innerText = innerText;

    return el;
}

/**
 * Funzione che genera un elemento `<img>`
 * @param {string} src source dell'immagine. Verrà inserito `"./../" + src` per raggiugere correttamente le immagini
 * @param {string} alt descrizione dell'immagine
 * @param {string} title title dell'immagine
 * @param {string} id id dell'immagine [Default `null`]
 * @param {string} classe classe dell'immagine [Default `null`]
 * @returns {HTMLElement} elemento `<img>` creato
 */
export function createHTML_img(src, alt, title = null, id = null, classe = null){
    const img = document.createElement("img");
    img.src = "./../../" + src;
    img.alt = alt;
    if(title)
        img.title = title;
    if(id)
        img.id = id;
    if(classe) 
        img.classList.add(classe);

    return img;
}

/**
 * Crea un pulsante con le proprietà specificate.
 * @param {String|null} type Il tipo del pulsante (es. "button", "submit").
 * @param {String|null} id L'id da assegnare al pulsante.
 * @param {String|null} text Il testo da visualizzare sul pulsante.
 * @param {Function|null} onClick La funzione da eseguire al click del pulsante.
 * @returns {HTMLButtonElement} Il pulsante creato.
 */
export function createButton(type = null, id = null, text = null, onClick = null){
    const btn = document.createElement("button");
    if(type)
        btn.type = type;
    if(id)
        btn.id = id;
    if(text)
        btn.innerText = text;
    if (onClick)
        btn.addEventListener("click", onClick);
    return btn;
}


/**
 * Crea un input per l'username con le relative proprietà e validazioni.
 * @param {String} labelTxt  Il testo del label associato.
 * @returns {Object} Un oggetto contenente il label e l'input creati.
 */
export function createUsernameInput(labelTxt){
    const label = document.createElement("label");
    const input = document.createElement("input");

    label.for = "username";
    label.innerText = labelTxt;
    input.type = "text";
    input.id = input.name = "username";
    input.toggleAttribute("required", true);

    input.pattern = patterns.USERNAME;
    input.title = "Deve iniziare con una lettera e avere tra 3 e 10 caratteri (lettere, punti o underscore).";
    input.placeholder = "User.0_";
    input.autocomplete = "off";
    input.addEventListener("input", validateForm);

    return {
        "label" : label,
        "input" : input
    };
}

/**
 * Crea un input per la password con un pulsante per mostrare/nascondere il contenuto.
 * @param {String} labelTxt Il testo del label associato.
 * @param {Boolean} isConfirm Indica se si tratta di un campo di conferma password [Default `false`].
 * @returns {Object} Un oggetto contenente il label e il contenitore della password.
 */
export function createPasswordInput(labelTxt, isConfirm = false){
    const label = document.createElement("label");
    
    label.for = (isConfirm)? "confirmPassword" : "password";
    label.innerText = labelTxt;
    
    const passwordContainer = document.createElement("div");
    passwordContainer.classList.add("password-container");
    
    const input = document.createElement("input");
    input.type = "password";
    input.id = input.name = (isConfirm)? "confirmPassword" : "password";
    input.toggleAttribute("required", true);
    input.pattern = patterns.PASSWORD;
    
    input.title = (isConfirm)? "Deve essere uguale alla password." : "Deve contenere almeno 8 caratteri, una lettera maiuscola, una minuscola, un numero e un carattere speciale.";
    
    input.placeholder = isConfirm ? "Conferma" : "Password";
    input.addEventListener("input", validateForm);
    if(isConfirm)
        input.classList.toggle("invalid", true);
    
    passwordContainer.appendChild(input);
    
    const toggleBtn = document.createElement("button");
    toggleBtn.type = "button";
    toggleBtn.innerText = "Mostra";
    toggleBtn.classList.add("toggle-password");
    toggleBtn.addEventListener("click", (e) => {
        hideShowPassword(e.target, isConfirm);
    });
    passwordContainer.appendChild(toggleBtn);

    return {
        "label": label,
        "passwordContainer": passwordContainer
    };
}

/**
 * Valida i campi del modulo con i seguenti id:
 * - username,
 * - password,
 * - conferma password
 * 
 * Se passano i test abilita/disabilita un pulsante con id "submit".
 */
export function validateForm(){
    let usr = document.getElementById("username");
    let psw = document.getElementById("password");
    let psw2 = document.getElementById("confirmPassword");
    let btn = document.getElementById("submit");
    let invalid = false;

    if(psw2 !== null && psw !== null){
        if(psw2.value === psw.value && psw.value !== ""){
            psw2.classList.toggle("invalid", false);
            psw2.classList.toggle("valid", true);
        }
        else{
            psw2.classList.toggle("valid", false);
            psw2.classList.toggle("invalid", true);
            invalid = true;
        }
    }

    if(usr !== null && !usr.checkValidity()){
        invalid = true;
    }

    if(psw !== null && !psw.checkValidity()){
        invalid = true;
    }

    btn.toggleAttribute("disabled", invalid);
}

/**
 * Mostra o nasconde il contenuto di un campo password.
 * @param {HTMLElement} target L'elemento che ha generato l'evento (es. pulsante toggle).
 * @param {Boolean} confirm Indica se si tratta del campo di conferma password. [Default `false`]
 */
export function hideShowPassword(target, confirm = false){
    let input;
    input = document.getElementById((confirm)? "confirmPassword" : "password");

    if (input.type === "password"){
        input.type = "text";
        target.innerText = "Nascondi";
    } else {
        input.type = "password";
        target.innerText = "Mostra";
    }
}


// *** Funzioni dedicate alla gestione di moduli in overlay *** //


/**
 * Mostra un modulo in sovraimpressione.
 * @param {String} id L'id del modulo da visualizzare.
 * @param {Boolean} showCoins Indica se portare in risalto le monete. [Default `false`]
 */
export function showModule(id, showCoins = false){
    let module = document.getElementById(id);
    if(showCoins){
        const coins = document.querySelector(".coin-display");
        coins.style = "z-index: 2";
    }
    module.classList.add("show");
}

/**
 * Nasconde ed elimina il contenuto di un modulo in sovraimpressione.
 * @param {Event} event L'evento che ha generato l'azione.
 * @param {String} id L'id del modulo da rimuovere.
 * @param {Boolean} override Indica se ignorare i controlli. [Default `false`]
 * @param {Boolean} showCoins Indica se rimuovere il focus sulle monete. [Default `false`]
 * @returns {Boolean} `true` se la rimozione ha avuto effetto, altrimenti `false`.
 */
export function closeModule(event, id, override = false, showCoins = false){
    const module = document.getElementById(id);
    if (override || event.target === module){
        module.classList.remove("show");
        if(showCoins){
            const coins = document.querySelector(".coin-display");
            coins.style = "z-index: 0";
        }

        while(module.childElementCount)
            module.removeChild(module.firstChild);


        return true;
    }
    return false;
}


// *** Funzioni dedicate alla gestione di messaggi e errori *** //


/**
 * Mostra un messaggio temporaneo sullo schermo che si rimuove automaticamente dopo 5 secondi.
 * @param {String} messaggio Il testo del messaggio da visualizzare.
 * @param {Number} showTime Per quanto tempo il messaggio rimane visibile [Default `1.5 secondi`]
 */
export function showMessage(messaggio, showTime = 1500){
    const messageContainer = createHTMLElement("div", "messaggio", null, messaggio);
    
    if(showTime === IMPORTANT_MESSAGE){
        messageContainer.classList.add("errore");
    }
    else if(showTime === GAME_MESSAGE){
        messageContainer.classList.add("gioco");
    }

    document.body.appendChild(messageContainer);

    setTimeout(() => {
        messageContainer.style.opacity = 0;
        messageContainer.style.transform = "translateY(-20px)";
    }, showTime);

    setTimeout(() => {
        document.body.removeChild(messageContainer);
    }, showTime + 3000);
}

/**
 * Gestisce un errore mostrando un messaggio all'utente e registrando l'errore nella console.
 * @param {Object} error Oggetto `JSON` che rappresenta l'errore da gestire, deve **necessariamente** avere almeno questi due campi
 * @param {string} error[].message - Il messaggio descrittivo dell'errore.
 * @param {string|number} error[].errorcode - Il codice identificativo dell'errore.
 */
export function errorHandler(error){
    showMessage(error.message, IMPORTANT_MESSAGE);
    console.error(`Errore: ${error.errorcode}: ${error.message}`);
}


// *** Funzioni dedicate alla gestione dell'inventario e monete *** //


/**
 * Mostra l'inventario dell'utente con id `"inventoryModule"`, recuperandolo tramite una richiesta API.
 * @param {Boolean} newItems Indica se evidenziare gli oggetti appena ottenuti [Default `false`]
 * @param {Boolean} equipment Indica l'inventario serve per equipaggiare oggetti (`true`) o per la sua gestione (`false`)[Default `false`]
 * @param {Array|null} filterObj filtro contenente i tipi degli oggetti da recuperare tramite API [Default `null`]
 */
export function showInventory(newItems = false, equipment = false, filterObj = null){
    if (currentlyOpened !== null && currentlyOpened !== "inventoryModule")
        return;

    const module = document.getElementById("inventoryModule");
    currentlyOpened = module.id;
    
    const formData = new FormData();
    formData.append("filter", JSON.stringify(filterObj));

    document.body.classList.add("caricamento");
    fetch('./../API/getInventory.php', {
        method: "POST",
        body: formData,
    })
        .then(response => response.json())
        .then(risposta => {
            document.body.classList.remove("caricamento");
            if (risposta.error !== undefined && risposta.error){
                throw risposta;
            }
            const data = risposta["inventario"];
            const MAX_SIZE = risposta["MAX_SIZE"];

            const page = document.createElement("div");
            page.classList.add("inventory-page");

            const container = document.createElement("div");
            container.classList.add("inventory-container");

            let objCount = data.length;

            data.slice().forEach((item, index) => {
                const space = createItemSlot(item, index, newItems);
                space.addEventListener("click", (e) => {
                    const id = String(e.target.id).replace(/^(img-|ic-)/, "");
                    const info = generateInfo("inventory-info", data[id], true, equipment);
                    changeItemInfo(info);
                });
                container.appendChild(space);
            });

            for(; objCount < MAX_SIZE; ++objCount){
                const space = document.createElement("div");
                space.classList.add("item-slot");
                space.addEventListener("click", () => {
                    const info = generateInfo("inventory-info", null, true, equipment);
                    changeItemInfo(info);
                });
                container.appendChild(space);
            }

            page.appendChild(container);

            const info = generateInfo("inventory-info", shownItem);

            page.appendChild(info);

            closeModule(null, module.id, true, false);
            module.appendChild(page);
            if(!equipment){
                const coins = document.querySelector(".coin-display");
                coins.style = "z-index: 2";
            }

            showModule(module.id, !equipment);
            moduleListener = (e) => {
                closeModuleEvent(e, "inventoryModule", false, !equipment);
            };
            window.addEventListener("click", moduleListener);
            ;
        })
        .catch(error => {
            errorHandler(error);
            return null;
        });
}

/**
 * Crea uno slot per un oggetto dell'inventario.
 * @param {Object} item L'oggetto dell'inventario.
 * @param {Number} id L'id dello slot.
 * @param {Boolean} newItems Indica se evidenziare gli oggetti appena ottenuti.
 * @returns {HTMLElement} Lo slot creato.
 */
function createItemSlot(item, id, newItems){
    const space = createHTMLElement("div", "item-slot", id);

    if (newItems && openedItems.includes(item.ID)){
        space.classList.add("newItem");
    }

    const img = createHTML_img(item.PathImmagine, item.Descrizione, item.Nome, `img-${id}`);
    space.appendChild(img);

    const count = createHTMLElement("div", "item-count", `ic-${id}`, item.Quantita);
    space.appendChild(count);

    return space;
}

/**
 * Genera un elemento HTML `<aside>` contenente le informazioni di un oggetto.
 * @param {String} id Id da assegnare all'aside
 * @param {Array|null} item Oggetto per il quale generare le informazioni. Se si vuole generare un elemento senza oggetto inserire `null`. [Default `null`]
 * @param {Boolean} hasIt Indica se l'oggetto è già di proprietà dell'utente o deve essere acquistato [Default `true`]
 * @param {Boolean} equipment Qualora `hasIt === true`, sancisce se l'oggetto deve essere equipaggiato (`true`) oppure va venduto `false` [Default `false`]
 * @returns {HTMLElement} Elemento HTML `<aside>` contenente le informazioni
 */
function generateInfo(id, item = null, hasIt = true, equipment = false){
    shownItem = item;
    openBoxSelected = false;
    const container = document.createElement("aside");
    container.id = id;

    if(item === null){
        const div = document.createElement("div");
        div.innerText = "Clicca su uno degli oggetti per ulteriori informazioni"

        container.appendChild(document.createElement("div"));
        container.appendChild(document.createElement("div"));
        container.appendChild(div);
    }
    else{
        let el = document.createElement("header");
        let p = document.createElement("p");

        p.innerText = item.Nome;
        el.appendChild(p);

        p = document.createElement("p");
        p.innerText = item.Tipologia;
        el.appendChild(p);

        container.appendChild(el);

        el = document.createElement("figure");

        const img = createHTML_img(item.PathImmagine, item.Descrizione);
        el.appendChild(img);

        p = document.createElement("figcaption");
        p.innerText = item.Elemento;
        el.appendChild(p);
        container.appendChild(el);

        p = document.createElement("p");
        p.classList.add("description");
        p.innerText = item.Descrizione;

        container.appendChild(p);

        el = createHTMLElement("div", "main-info-section");

        if(hasIt && item.Tipologia === "box"){
            const open = createButton("button", "open", "Apri", openBox);
            openBoxSelected = true;

            el.appendChild(open);
        }
        else if(item.Tipologia !== "box"){
            const table = document.createElement("table");

            let tr = document.createElement("tr");
            let td = createHTMLElement("td", null, null, null);
            let modificatore;
            let txt;

            switch(item.Tipologia){
                case "arma":
                    modificatore = "Danno";
                    txt = "Bonus Danno";
                    break;
                case "armatura":
                    modificatore = "ProtezioneDanno";
                    txt = "Protezione Danno";
                    break;
                default:
                    modificatore = "RecuperoVita";
                    txt = "Bonus PF";
            }
            td.innerText = txt;
            tr.appendChild(td);

            td = createHTMLElement("td", null, null, String(item[modificatore]));
            tr.appendChild(td);
            table.appendChild(tr);

            tr = document.createElement("tr");
            td = createHTMLElement("td", null, null, "Modificatore FOR");
            tr.appendChild(td);
            td = createHTMLElement("td", null, null, String(item.ModificatoreFor));
            tr.appendChild(td);
            table.appendChild(tr);

            tr = document.createElement("tr");
            td = createHTMLElement("td", null, null, "Modificatore DES");
            tr.appendChild(td);
            td = createHTMLElement("td", null, null, String(item.ModificatoreDes));
            tr.appendChild(td);

            table.appendChild(tr);
            el.appendChild(table);
        }
        else{
            const div = document.createElement("div");
            el.appendChild(div);
        }

        container.appendChild(el);

        el = document.createElement("footer");

        let btn = null;
        btn = (hasIt)? 
            ((equipment)?
                createButton("button", "equip-btn", "Equipaggia", equipItem):
                createButton("button", "sell-btn", "Vendi: " + Math.floor(item.Costo / 2) + "🪙", sellItem)
            ):
            createButton("button", "buy-btn", "Compra: " + item.Costo + "🪙", buyItem);

        el.appendChild(btn);
        btn = createButton("button", null, "Chiudi", () => {
            let info = generateInfo(id);
            changeItemInfo(info);
            shownItem = null;
        });
        
        el.appendChild(btn);

        container.appendChild(el);
    }

    return container;
}

/**
 * Aggiorna la sezione dettagli del modulo attualmente aperto `currentlyOpened` con i dettagli di un oggetto selezionato.
 * @param {HTMLElement} info Elemento HTML contenente le nuove informazioni dell'oggetto
 */
function changeItemInfo(info){
    if(currentlyOpened === null)
        return
    let module = document.getElementById(currentlyOpened);
    module = module.firstChild;
    module.removeChild(module.lastChild);
    module.appendChild(info);
}

/**
 * Se `currentlyOpened === inventoryModule`, e `shownItem !== null` effettua una richiesta API per vendere `showItem`
 */
function sellItem(){
    if(currentlyOpened !== "inventoryModule"){
        showMessage("Impossibile vendere un oggetto da questa interfaccia");
        return;
    }
    if(!shownItem){
        showMessage("Nessun Oggetto da Vendere");
        return;
    }
    document.body.classList.add("caricamento");
    fetch('./../API/sellItem.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            "itemId": shownItem.ID
        })
    })
    .then(response => response.json())
    .then(data => {
        document.body.classList.remove("caricamento");
        if(data.error !== undefined && data.error){
            throw data;
        }
        else{
            updateCoins(data.guadagno);
            if(data.rimosso){
                shownItem = null;
            }
            showInventory();
            showMessage(`Vendita effettuata | +${data.guadagno}🪙`);
        }
    })
    .catch(error => {
        errorHandler(error);
        return;
    });
}

/**
 * Aggiorna il contatore delle monete dell'utente con id `"coin-count"`.
 * @param {Number} amount Quantità di monete da aggiungere o sottrarre
 */
function updateCoins(amount){
    let coins = document.getElementById("coin-count");
    coins.innerText = Number(coins.innerText) + amount;
}

/**
 * Se `currentlyOpened === inventoryModule` e `shownItem.Tipologia === "box"`, allora effettua una richiesta API per aprire la box e recuperare i nuovi oggetti.
 */
export function openBox(){
    if(currentlyOpened !== "inventoryModule")
        return;

    if(shownItem.Tipologia !== "box"){
        showMessage("Oggetto Non apribile");
        return;
    }

    document.body.classList.add("caricamento");
    fetch("./../API/openBox.php", {
        method: "POST",
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body : new URLSearchParams({
            'boxID' : shownItem.ID,
            'boxNome': shownItem.Nome
        })
    })
    .then(response => response.json())
    .then(data =>{
        document.body.classList.remove("caricamento");
        if(data.error !== undefined && data.error){
            throw data;
        }
        else if(data.full){
            showMessage("Non hai abbastanza slot!");
        }
        else{
            updateCoins(data.guadagno);
            openedItems = data.itemsID;
            if(data.rimosso){
                shownItem = null;
            }
            showInventory(currentlyOpened);
            showMessage(`Box Aperta! | +${data.guadagno}🪙`);
        }
    })
    .catch(error => {
        errorHandler(error);
        return;
    });
}

/**
 * Chiude un modulo sopraelevato (overlay) dal DOM.
 * @param {Event} event Evento generatore
 * @param {String} id ID del modulo da rimuovere
 * @param {Boolean} overload Indica se effettuare il controllo sull'evento [Default `false`]
 * @param {Boolean} coins Indica se è presente il counter di monete da rimuovere o meno. [Default `true`]
 */
export function closeModuleEvent(event, id, overload = false, coins = true){
    if (moduleListener === null || currentlyOpened !== id)
        return;

    const module = document.getElementById(id);
    if (overload || event.target === module){
        window.removeEventListener("click", moduleListener);
        moduleListener = null;
        openBoxSelected = false;
        shownItem = null;
        currentlyOpened = null;
        if (shopTimer !== null){
            shopTimer.clearTimer();
            shopTimer = null;
        }
        closeModule(null, id, true, coins);
    }
}


// *** Funzioni dedicate al menu perosnalizzazione Account *** //


/**
 * Mostra il menu principale con id `"menuModule"` con le opzioni per cambiare username, cambiare password o eliminare l'account.
 */
export function showMenu(){
    if (currentlyOpened !== null && currentlyOpened !== "menuModule"){
        return;
    }

    const module = document.getElementById("menuModule");
    currentlyOpened = module.id;
    
    const page = document.createElement("div");
    page.classList.add("menu-page");

    const menuOptions = [
        {
            id: "changeImg",
            text: "Cambia Immagine",
            action: changeImage
        },
        {
            id: "changeUsr",
            text: "Cambia Username",
            action: changeUsername
        },
        {
            id: "changePwd",
            text: "Cambia Password",
            action: changePassword
        },
        {
            id: "deleteAccount",
            text: "Elimina Account",
            action: deleteAccount
        }
    ];

    menuOptions.forEach((option) => {
        const div = document.createElement("div");
        div.classList.add("menu-space");

        const p = createHTMLElement("p", null, option.id, option.text);
        p.addEventListener("click", option.action);
        div.appendChild(p);
        page.appendChild(div);
    });

    closeModule(null, "menuModule", true);
    module.appendChild(page);
    showModule(module.id);
    moduleListener = (e) => {
        closeModuleEvent(e, "menuModule");
    };
    window.addEventListener("click", moduleListener);
    ;
}

/**
 * Mostra il modulo per cambiare l'username dell'utente.
 */
function changeUsername(){
    if(currentlyOpened !== "menuModule"){
        return;
    }

    const module = document.getElementById("menuModule");

    const page = document.createElement("div");
    page.classList.add("username-page");

    let space = document.createElement("div");
    space.classList.add("menu-space");
    space.classList.add("header");

    let el = document.createElement("h2");
    el.innerText = "Username Attuale:";
    space.appendChild(el);

    el = document.createElement("p");
    el.innerText = USERNAME;

    space.appendChild(el);
    page.appendChild(space);

    space = document.createElement("div");
    space.classList.add("menu-space");

    const form = document.createElement("form");
    form.classList.add("username");
    form.action = "./../handlers/changeCredentials.php";
    form.method = "POST";

    el = createUsernameInput("Nuovo Username:");
    form.appendChild(el.label);
    form.appendChild(el.input);

    el = createButton("submit", "submit", "Conferma");
    el.toggleAttribute("disabled", true);
    form.appendChild(el);

    el = createButton("button", "backToMenu", "Annulla", showMenu);
    form.appendChild(el);

    space.appendChild(form);
    page.appendChild(space);

    while(module.childElementCount){
        module.removeChild(module.lastChild);
    }

    module.appendChild(page);
}

/**
 * Mostra il modulo per cambiare la password dell'utente.
 */
function changePassword(){
    if(currentlyOpened !== "menuModule"){
        return;
    }

    const module = document.getElementById("menuModule");

    const page = document.createElement("div");
    page.classList.add("password-page");

    let space = document.createElement("div");
    space.classList.add("menu-space");
    space.classList.add("header");

    let el = document.createElement("h2");
    el.innerText = "Cambio Password";
    space.appendChild(el);

    page.appendChild(space);

    space = document.createElement("div");
    space.classList.add("menu-space");

    const form = document.createElement("form");
    form.classList.add("password");
    form.action = "./../handlers/changeCredentials.php";
    form.method = "POST";

    el = createPasswordInput("Nuova Password:", false);
    form.appendChild(el.label);
    form.appendChild(el.passwordContainer);

    el = createPasswordInput("Conferma Password:", true);
    form.appendChild(el.label);
    form.appendChild(el.passwordContainer);

    el = createButton("submit", "submit", "Conferma");
    el.toggleAttribute("disabled", true);
    form.appendChild(el);

    el = createButton("button", "backToMenu", "Annulla", showMenu);
    form.appendChild(el);

    space.appendChild(form);
    page.appendChild(space);

    while(module.childElementCount){
        module.removeChild(module.lastChild);
    }

    module.appendChild(page);
}

/**
 * Mostra il modulo per eliminare l'account dell'utente.
 */
function deleteAccount(){
    if(currentlyOpened !== "menuModule"){
        return;
    }

    const module = document.getElementById("menuModule");

    const page = document.createElement("div");
    page.classList.add("delete-page");

    let space = document.createElement("div");
    space.classList.add("menu-space");
    space.classList.add("header");

    let el = document.createElement("h2");
    el.innerText = "Stai per Eliminare l'account";
    space.appendChild(el);

    el = document.createElement("p");
    el.innerText = "Sei sicuro?";

    space.appendChild(el);
    page.appendChild(space);

    space = document.createElement("div");
    space.classList.add("menu-space");

    const form = document.createElement("form");
    form.action = "./../handlers/changeCredentials.php";
    form.method = "POST";

    // Lo sfrutto per capire se la richiesta è o meno di elimina account
    const phantomCheck = document.createElement("input");

    phantomCheck.type = "checkbox";
    phantomCheck.name = phantomCheck.id = "deleteCheck";
    phantomCheck.value = "1";
    phantomCheck.toggleAttribute("checked", true);
    phantomCheck.toggleAttribute("hidden", true);

    form.appendChild(phantomCheck);

    el = document.createElement("p");
    el.innerText = "Eliminando l'account ";
    const boldText = document.createElement("b");
    boldText.innerText = "perderai in maniera definitiva tutti i tuoi progressi";
    el.appendChild(boldText);
    el.appendChild(document.createTextNode(", sei sicuro di volerlo fare?"));
    form.appendChild(el);

    const aside = document.createElement("aside");
    aside.classList.add("button-holder");

    el = createPasswordInput("Conferma con Password:");
    aside.appendChild(el.label);
    aside.appendChild(el.passwordContainer);

    el = createButton("submit", "submit", "Elimina");
    el.toggleAttribute("disabled", true);
    aside.appendChild(el);

    el = createButton("button", "backToMenu", "Annulla", showMenu);
    aside.appendChild(el);
    form.appendChild(aside);

    space.appendChild(form);
    page.appendChild(space);

    while(module.childElementCount){
        module.removeChild(module.lastChild);
    }

    module.appendChild(page);
}

/**
 * Mostra il modulo per cambiare l'immagine dell'utente
 */
function changeImage(){
    if(currentlyOpened !== "menuModule"){
        return;
    }

    const module = document.getElementById("menuModule");
    document.body.classList.add("caricamento");
    fetch('./../API/getElementPics.php')
        .then(risposta => risposta.json())
        .then(images => {
            document.body.classList.remove("caricamento");
            if(images.error !== undefined && images.error){
                throw images;
            }
            const page = document.createElement("div");
            page.classList.add("image-page");

            let space = document.createElement("div");
            space.classList.add("menu-space");
            space.classList.add("header");

            let el = document.createElement("h2");
            el.innerText = "Cambia Immagine:";
            space.appendChild(el);
            page.appendChild(space);

            space = document.createElement("div");
            space.classList.add("menu-space");

            const form = document.createElement("form");;
            form.classList.add("image");
            form.action = "./../handlers/changeCredentials.php";
            form.method = "POST";

            el = document.createElement("div");
            el.classList.add("choose-box");

            images.forEach((imagePath, index) => {
                const imageName = imagePath.split('/').pop();
                const option = document.createElement("div");
                option.classList.add("image-option");

                let tmp = document.createElement("input");
                tmp.type = "radio";
                tmp.id = `pic-${index}`;
                tmp.name = "newPic";
                tmp.value = imagePath;
                tmp.toggleAttribute("required", true);

                if(imageName === document.getElementById("userPic").src.split('/').pop())
                    tmp.toggleAttribute("checked", true);

                option.appendChild(tmp);

                tmp = document.createElement("label");
                tmp.setAttribute('for', `pic-${index}`)

                const img = createHTML_img(imagePath, `Pic ${imageName}`);
                img.draggable = false;

                tmp.appendChild(img);
                option.appendChild(tmp);

                el.appendChild(option);
            });
            form.appendChild(el);

            el = createButton("submit", "submit", "Conferma");
            form.appendChild(el);

            el = createButton("button", "backToMenu", "Annulla", showMenu);
            form.appendChild(el);

            space.appendChild(form);
            page.appendChild(space);

            while(module.childElementCount){
                module.removeChild(module.lastChild);
            }

            module.appendChild(page);
        })
        .catch(error => {
            errorHandler(error);
            return;
        });
}


// *** Funzioni dedicate alla gestione del negozio  *** //


/**
 * Mostra il negozio dell'utente con id `"shopModule"`, recuperando le informazioni tramite richiesta API.
 */
export function showShop(){
    if(currentlyOpened !== null && currentlyOpened !== "shopModule")
        return;
    const module = document.getElementById("shopModule");
    currentlyOpened = module.id;
    
    shownItem = null;
    if(shopTimer !== null){
        shopTimer.clearTimer();
        shopTimer = null;
    }

    document.body.classList.add("caricamento");
    fetch('./../API/getShopItems.php')
        .then(response => response.json())
        .then(risposta => {
            document.body.classList.remove("caricamento");
            if(risposta.error !== undefined && risposta.error){
                throw risposta;
            }
            const data = risposta.items;
            const remainingTime = risposta.remainingTime;

            const page = document.createElement("div");
            page.classList.add("shop-page");

            const container = document.createElement("div");
            container.classList.add("shop-container");

            let el = document.createElement("header");
            el.classList.add("timer-container");

            const p = createHTMLElement("p", "timer", "", `Prossimo Refresh \u2003 - \u2003`);

            const span = createHTMLElement("span", "", "timer", `${remainingTime.minutes}:${remainingTime.seconds}`);
            
            shopTimer = new Timer(showShop, 1000);

            p.appendChild(span);
            el.appendChild(p);

            container.appendChild(el);

            el = document.createElement("div");
            el.classList.add("shop-slots");

            data.slice().forEach((item, index) => {
                const space = createShopSlot(item, index);

                space.addEventListener("click", (e) => {
                    const id = String(e.target.id).replace(/^(img-|cap-)/, "");
                    const info = generateInfo("shop-info", data[id], false);
                    changeItemInfo(info);
                });

                el.appendChild(space);
            });

            container.appendChild(el);
            page.appendChild(container);

            const info = generateInfo("shop-info", shownItem, false);

            page.appendChild(info);

            closeModule(null, module.id, true, false);
            module.appendChild(page);
            showModule(module.id, true);
            moduleListener = (e) => {
                closeModuleEvent(e, "shopModule");
            };

            window.addEventListener("click", moduleListener);
            ;
        })
        .catch(error => {
            errorHandler(error);
            return null;
        });


}

/**
 * Funzione di supporto per creare uno slot negozio per un oggetto.
 * @param {Array} item Oggetto da visualizzare
 * @param {Number} id Indice da assegnare all'oggetto
 * @returns {HTMLElement} Elemento HTML rappresentante lo slot dell'oggetto nel negozio
 */
function createShopSlot(item, id){
    const space = createHTMLElement("div", "shop-slot", id);

    const img = createHTML_img(item.PathImmagine, item.Descrizione, item.Nome, `img-${id}`);
    space.appendChild(img);

    const caption = createHTMLElement("div", null, `cap-${id}`, `${item.Costo}🪙`);
    space.appendChild(caption);

    return space;
}

/**
 * Se `currentlyOpened === "shopModule"` e `shownItem!== null`, effettua una richiesta API per acquistare l'oggetto `shownItem`
 */
function buyItem(){
    if(currentlyOpened !== "shopModule"){
        showMessage("Impossibile acquistare un oggetto da questa interfaccia");
        return;
    }
    if(!shownItem){
        showMessage("Nessun Oggetto da Acquistare");
        return;
    }
    document.body.classList.add("caricamento");
    fetch('./../API/buyItem.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            'itemId': shownItem.ID
        })
    })
    .then(response => response.json())
    .then(data => {
        document.body.classList.remove("caricamento");
        if(data.error !== undefined && data.error){
            throw data;
        }
        else{
            updateCoins(data.spesa);
            showMessage(`Acquisto effettuato | ${data.spesa}🪙`);
        }
    })
    .catch(error => {
        errorHandler(error);
        return;
    });
}


// *** Funzioni dedicate alla gestione del Personaggio  *** //

/**
 * Mostra la schermata di eliminazione Personaggio con id `"deleteModule"`.
 */
export function createDeleteBox(){
    if(currentlyOpened !== null && currentlyOpened !== "deleteModule"){
        return;
    }

    const module = document.getElementById("deleteModule");
    currentlyOpened = module.id;

    const page = document.createElement("div");
    page.classList.add("delete-page");

    let space = document.createElement("div");
    space.classList.add("menu-space");
    space.classList.add("header");

    let el = document.createElement("h2");
    el.innerText = "Stai per Eliminare il personaggio";
    space.appendChild(el);

    el = document.createElement("p");
    el.innerText = "Sei sicuro?";

    space.appendChild(el);
    page.appendChild(space);

    space = document.createElement("div");
    space.classList.add("menu-space");

    const form = document.createElement("form");
    form.action = "./../handlers/handlePG.php";
    form.method = "POST";

    // Lo sfrutto per capire se la richiesta è o meno di elimina account
    const phantomCheck = document.createElement("input");

    phantomCheck.type = "checkbox";
    phantomCheck.name = phantomCheck.id = "deleteCheck";
    phantomCheck.value = "1";
    phantomCheck.toggleAttribute("checked", true);
    phantomCheck.toggleAttribute("hidden", true);

    form.appendChild(phantomCheck);

    el = document.createElement("p");
    el.innerText = "Eliminando il personaggio ";
    const boldText = document.createElement("b");
    boldText.innerText = "lo perderai in maniera definitiva";
    el.appendChild(boldText);
    el.appendChild(document.createTextNode(", sei sicuro di volerlo fare?\nGli oggetti nello zaino verranno inviati al tuo inventario."));
    form.appendChild(el);

    const aside = document.createElement("aside");
    aside.classList.add("button-holder");

    el = createButton("submit", "submit", "Elimina");
    aside.appendChild(el);

    el = createButton("button", "backToMenu", "Annulla", () => {
        closeModuleEvent(null, module.id, true, false);
    });
    
    aside.appendChild(el);
    form.appendChild(aside);

    space.appendChild(form);
    page.appendChild(space);

    while(module.childElementCount){
        module.removeChild(module.lastChild);
    }

    closeModule(null, module.id, true, false);
    module.appendChild(page);
    showModule(module.id);
    moduleListener = (e) => {
        closeModuleEvent(e, module.id, false, false);
    };
    window.addEventListener("click", moduleListener);
}

/**
 * Funzione che, se `shownItem !== null`, effettua una richiesta API per equipaggiare l'item al personaggio di riferimento
 */
function equipItem(){
    if(!shownItem){
        showMessage("Nessun Oggetto da Equipaggiare");
        return;
    }
    const formData = new FormData();
    formData.append("itemId", Number(shownItem.ID));

    fetch("./../API/togglePGItem.php", {
        method: "POST",
        body: formData
    })
    .then(response => response.json())
    .then(esito =>{
        if(esito.error !== undefined && esito.error === true){
            throw esito;
        }
        window.location.reload();
    })
    .catch(error =>{
        errorHandler(error);
    });
}