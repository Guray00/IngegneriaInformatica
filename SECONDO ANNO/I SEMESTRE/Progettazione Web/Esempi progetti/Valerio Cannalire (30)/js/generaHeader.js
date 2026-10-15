/**
 * Genera dinamicamente l'interfaccia dell'intestazione del sito.
 * @param {Object} opzioni - Oggetto contenente i flag di configurazione.
 * @param {boolean} opzioni.guida - Se true, include l'icona della guida '?'.
 * @param {string} opzioni.percorsoGuida - Flag per percorso relativo per raggiungere guida.html
 * @param {boolean} opzioni.profilo - Se true, include il blocco profilo/logout.
 * @param {string} opzioni.nomeUtente - Il nome dell'utente loggato (obbligatorio se profilo è true).
 * @param {string|null} opzioni.linkDestinazione - URL di destinazione del titolo. 
 * Se null, il titolo non sarà un link.
 */
 function generaHeader(opzioni) {
    const nodoHeader = document.querySelector("header");
    if (!nodoHeader) {
        alert("Impossibile generare l'intestazione: tag <header> non trovato nel DOM.");
        return;
    }

    nodoHeader.innerHTML = "";

    // 1. guida
    if (opzioni.guida) {
        const linkGuida = document.createElement("a");
        linkGuida.className = "icona-guida";
        linkGuida.title = "Guida all'uso";
        linkGuida.textContent = "?";
        linkGuida.href = opzioni.percorsoGuida ? "../html/guida.html" : "html/guida.html";
        nodoHeader.appendChild(linkGuida);
    }
    else {
        // inserimento div vuoto per occupare la prima colonna della griglia
        const segnapostoSinistro = document.createElement("div");
        nodoHeader.appendChild(segnapostoSinistro);
    }

    // 2. titolo del sito
    const divTitoloSito = document.createElement("div");
    divTitoloSito.className = "titolo-sito";

    const h1Sito = document.createElement("h1");
    h1Sito.textContent = "Consigli Non Richiesti";

    const pSito = document.createElement("p");
    pSito.textContent = "Il posto dove troverai i suggerimenti di cui non sapevi di aver bisogno.";

    // link nel titolo
    if (opzioni.linkDestinazione) {
        const linkIdentita = document.createElement("a");
        linkIdentita.href = opzioni.linkDestinazione;
        linkIdentita.className = "identita-sito";
        linkIdentita.title = opzioni.linkDestinazione === "home.php" ? "Torna alla home" : "Vai alla pagina";
        
        linkIdentita.appendChild(h1Sito);
        linkIdentita.appendChild(pSito);
        divTitoloSito.appendChild(linkIdentita);
    } else {
        // se il link è assente si crea un div generico
        const divInvolucroTesto = document.createElement("div");
        
        divInvolucroTesto.appendChild(h1Sito);
        divInvolucroTesto.appendChild(pSito);
        divTitoloSito.appendChild(divInvolucroTesto);
    }
    // nome forum/utente/vuoto
    const divScatolaForum = document.createElement("div");
    const h1Forum = document.createElement("h1");
    const spanForum = document.createElement("span");
    spanForum.id = "nome-forum";

    h1Forum.appendChild(spanForum);
    divScatolaForum.appendChild(h1Forum);
    divTitoloSito.appendChild(divScatolaForum);

    nodoHeader.appendChild(divTitoloSito);

    // 3. profilo
    if (opzioni.profilo) {
        const divProfilo = document.createElement("div");
        divProfilo.className = "profilo";

        const linkProfilo = document.createElement("a");
        linkProfilo.href = "profilo.php";
        linkProfilo.textContent = opzioni.nomeUtente ? opzioni.nomeUtente : "Profilo";

        divProfilo.appendChild(linkProfilo);
        nodoHeader.appendChild(divProfilo);
    }
}