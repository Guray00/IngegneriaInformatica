let containerIscritto, containerPropri, containerRisultatiRicerca;
let overlay, dialog, btnApri, btnChiudi, formCreazione, errCreazione, inputCreazione;
let barraRicerca;

//crea la struttura per la scheda di un forum
function schedaForum(forum) {
    const scheda = document.createElement("article");
    scheda.className = "scheda-forum";
    scheda.dataset.idForum = forum.id_forum;

    const schedaTop = document.createElement("div");
    schedaTop.className = "scheda-top";

    const nomeForum = document.createElement("span");
    nomeForum.title = forum.nome_forum;
    nomeForum.textContent = forum.nome_forum;

    const iconeTop = document.createElement("div");
    iconeTop.className = "icone-top";

    // gestione icone di status
    if (forum.is_iscritto) {
        const iconaIscritto = document.createElement("span");
        iconaIscritto.className = "icona-status";
        iconaIscritto.title = "Partecipi a questo forum";
        iconaIscritto.textContent = "✔️";
        iconeTop.appendChild(iconaIscritto);
    }
    if (forum.is_admin) {
        const iconaAdmin = document.createElement("span");
        iconaAdmin.className = "icona-status";
        iconaAdmin.title = "Sei l'amministratore di questo forum";
        iconaAdmin.textContent = "👑";
        iconeTop.appendChild(iconaAdmin);
    }

    schedaTop.appendChild(nomeForum);
    schedaTop.appendChild(iconeTop);

    const adminForum = document.createElement("div");
    adminForum.className = "admin-forum";
    adminForum.textContent = "Admin: ";
    const linkProfiloAdmin = document.createElement("a");
    linkProfiloAdmin.href = `profilo.php?utente=${forum.creatore}`;
    linkProfiloAdmin.className = "link-autore-admin"; 
    linkProfiloAdmin.textContent = forum.creatore;

    // impedisce conflitto tra apertura del profilo admin e apertura forum
    linkProfiloAdmin.addEventListener("click", function(evento) {
        evento.stopPropagation(); 
    });

    adminForum.appendChild(linkProfiloAdmin); 

    const iconeBottom = document.createElement("div");
    iconeBottom.className = "icone-bottom";

    // numero di iscritti
    const statIscritti = document.createElement("div");
    statIscritti.className = "icona-statistica";
    statIscritti.title = "Utenti iscritti";
    statIscritti.textContent = "👥 "; 
    statIscritti.appendChild(document.createTextNode(forum.totale_iscritti)); // Testo dinamico senza span

    // numero di post
    const statPost = document.createElement("div");
    statPost.className = "icona-statistica";
    statPost.title = "Post totali";
    statPost.textContent = "📝 "; 
    statPost.appendChild(document.createTextNode(forum.totale_post));
    
    iconeBottom.appendChild(statIscritti);
    iconeBottom.appendChild(statPost);

    scheda.appendChild(schedaTop);
    scheda.appendChild(adminForum);
    scheda.appendChild(iconeBottom);

    scheda.addEventListener("click", function(evento) {
        // se il click è avvenuto sul link dell'admin comportamento nativo del browser senza interferire
        if (evento.target.closest("a")) {
            return;
        }
        // altrimenti si apre la pagina del forum
        window.location.href = `forum.php?id=${this.dataset.idForum}`;
    });

    return scheda;
}

// carica dal server i forum creati dall'utente e quelli a cui è iscritto
function caricaForum() {
    fetch("get_forum.php", {
        method: "POST"
    })
    .then(function(risposta) {
        if (!risposta.ok) {
            throw new Error("Il server ha risposto con status " + risposta.status);
        }
        return risposta.json();
    })
    .then(function(dati) {
        generaHeader({
            guida: true,
            percorsoGuida: true,
            profilo: true,
            nomeUtente: dati.username_loggato, 
            linkDestinazione: null
        });

        containerIscritto.innerHTML = "";
        containerPropri.innerHTML = "";

        function popolaColonna(listaForum, contenitoreTarget, messaggioVuoto) {
            if (!listaForum || listaForum.length === 0) {
                const avviso = document.createElement("p");
                avviso.className = "messaggio-vuoto";
                avviso.textContent = messaggioVuoto;
                contenitoreTarget.appendChild(avviso);
            } else {
                listaForum.forEach(function(forum) {
                    const scheda = schedaForum(forum);
                    contenitoreTarget.appendChild(scheda);
                });
            }
        }

        popolaColonna(dati.iscritto, containerIscritto, "Non partecipi a nessun forum.");
        popolaColonna(dati.propri, containerPropri, "Non hai ancora creato forum.");
    })
    .catch(function(errore) {
        alert("Errore nel caricamento dei forum:", errore);
    });
}

function creaForum() {
    const datiForm = new FormData(formCreazione);

    fetch("crea_forum.php", {
        method: "POST",
        body: datiForm
    })
    .then(function(risposta) {
        if (!risposta.ok)
            throw new Error();
        return risposta.text();
    })
    .then(function(messaggio) {
        if (messaggio === "OK") {
            // messaggio di successo
            const contenutoOriginale = Array.from(formCreazione.children);

            formCreazione.innerHTML = "";
            const testoSuccesso = document.createElement("p");
            testoSuccesso.className = "overlay-successo";
            testoSuccesso.textContent = "Forum creato con successo! 🎉";
            
            formCreazione.appendChild(testoSuccesso);

            // aggiornamento liste
            caricaForum();

            // reset
            setTimeout(function() {
                dialog.open = false;      
                overlay.classList.add("nascosto");
                
                formCreazione.innerHTML = "";
                contenutoOriginale.forEach(function(figlio) {
                    formCreazione.appendChild(figlio);
                });
                formCreazione.reset();
            }, 2000);
        } else
            errCreazione.textContent = messaggio;
    })
    .catch(function() {
        errCreazione.textContent = "Errore di connessione o operazione non consentita.";
    });
}

function ricercaForum() {
    const testoCercato = barraRicerca.value.trim();

    if (testoCercato === "") {
        containerRisultatiRicerca.innerHTML = "";
        return; 
    }

    const datiInvia = new FormData();
    datiInvia.append("chiave_ricerca", testoCercato);

    fetch("cerca_forum.php", {
        method: "POST",
        body: datiInvia
    })
    .then(function(risposta) {
        if (!risposta.ok) {
            throw new Error("Errore nella ricerca");
        }
        return risposta.json();
    })
    .then(function(forumTrovati) {
        containerRisultatiRicerca.innerHTML = "";

        if (!forumTrovati || forumTrovati.length === 0) {
            const avviso = document.createElement("p");
            avviso.className = "messaggio-vuoto";
            avviso.textContent = "Nessun forum corrisponde alla ricerca.";
            containerRisultatiRicerca.appendChild(avviso);
            return;
        }

        forumTrovati.forEach(function(forum) {
            const scheda = schedaForum(forum);
            containerRisultatiRicerca.appendChild(scheda);
        });
    })
    .catch(function(errore) {
        alert("Errore AJAX durante la ricerca:", errore);
    });
}

function inizializza() {
    containerIscritto = document.getElementById("lista-iscritto");
    containerPropri = document.getElementById("lista-propri");
    containerRisultatiRicerca = document.getElementById("lista-ricerca");

    overlay = document.getElementById("dialog-overlay");
    dialog = document.getElementById("dialog-crea");
    generaDialog("forum");
    btnApri = document.getElementById("btn-apri-dialog");
    btnChiudi = document.getElementById("btn-chiudi-dialog");
    formCreazione = document.getElementById("form-crea");
    errCreazione = document.getElementById("err-creazione");
    inputCreazione = document.getElementById("nome-nuovo");

    barraRicerca = document.getElementById("barra-ricerca");

    btnApri.addEventListener("click", function() {
        errCreazione.innerHTML = "&nbsp;";
        formCreazione.reset();                
        dialog.open = true;
        overlay.classList.remove("nascosto");         
    });

    btnChiudi.addEventListener("click", function() {
        dialog.open = false;      
        overlay.classList.add("nascosto");
    });

    // reset dinamico degli errori nel form mentre l'utente ricomincia a digitare
    inputCreazione.addEventListener("input", function() {
        errCreazione.innerHTML = "&nbsp;";
    });

    formCreazione.addEventListener("submit", function(event) {
        event.preventDefault(); // impedisce il ricaricamento nativo della pagina PHP
        creaForum();
    });

    barraRicerca.addEventListener("input", ricercaForum);
    barraRicerca.addEventListener("search", ricercaForum);

    caricaForum();
}

document.addEventListener("DOMContentLoaded", function() {
    inizializza();
});