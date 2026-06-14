//funzione che crea la struttura DOM interattiva di un post
function schedaPost(post) {
    const article = document.createElement("article");
    article.className = "scheda-post";
    article.dataset.idPost = post.id_post;

    if (post.segnalazioni >= 5) {
        article.classList.add("segnalato");
    }

    const classeLike = (post.mia_interazione === 'like') ? 'voto-attivo' : '';
    const classeDislike = (post.mia_interazione === 'dislike') ? 'voto-attivo' : '';
    const classeSegnala = (post.segnalato_da_me === 1) ? 'segnala-attivo' : '';

    // 1. Intestazione del Post
    const postHeader = document.createElement("div");
    postHeader.className = "post-header";

    const postAutore = document.createElement("a");
    postAutore.className = "link-profilo";
    postAutore.href = `profilo.php?utente=${post.autore}`;
    postAutore.textContent = "@" + post.autore;

    const postTitoloTesto = document.createElement("h2");
    postTitoloTesto.className = "post-titolo-testo";
    postTitoloTesto.textContent = post.titolo ? post.titolo : "Senza Titolo";

    const postData = document.createElement("span");
    postData.className = "post-data";
    postData.textContent = post.data;

    postHeader.appendChild(postAutore);
    postHeader.appendChild(postTitoloTesto);
    postHeader.appendChild(postData);

    // 2. Corpo del Post
    const postContenuto = document.createElement("p");
    postContenuto.className = "post-contenuto";
    postContenuto.textContent = post.contenuto;

    // 3. Sezione dei Tag
    const postTopicTags = document.createElement("div");
    postTopicTags.className = "post-topic-tags";
    post.tags.forEach(function(tag) {
        const tagSpan = document.createElement("span");
        tagSpan.className = "tag";
        tagSpan.textContent = "#" + tag;
        postTopicTags.appendChild(tagSpan);
    });

    // 4. Footer del Post con tasti interazione
    const postFooter = document.createElement("div");
    postFooter.className = "post-footer";

    const postValutazione = document.createElement("div");
    postValutazione.className = "post-valutazione";

    const btnLike = document.createElement("button");
    btnLike.type = "button";
    btnLike.className = "btn-voto btn-like " + classeLike;
    btnLike.textContent = "👍";
    if (post.segnalazioni >= 5) btnLike.disabled = true;

    const punteggioTotale = document.createElement("span");
    punteggioTotale.className = "punteggio-totale";
    punteggioTotale.textContent = post.ranking >= 0 ? "+" + post.ranking : post.ranking;

    const btnDislike = document.createElement("button");
    btnDislike.type = "button";
    btnDislike.className = "btn-voto btn-dislike " + classeDislike;
    btnDislike.textContent = "👎";
    if (post.segnalazioni >= 5) btnDislike.disabled = true;

    // tasti interazione disabilitati se l'utente non è iscritto
    if (STATO_FORUM.isIscritto) {
        btnLike.addEventListener("click", function() {
            votaPost(post.id_post, 'like', btnLike, btnDislike, punteggioTotale);
        });
        btnDislike.addEventListener("click", function() {
            votaPost(post.id_post, 'dislike', btnLike, btnDislike, punteggioTotale);
        });
    } else {
        btnLike.disabled = true;
        btnDislike.disabled = true;
        btnLike.title = "Iscriviti al forum per poter votare questo consiglio";
        btnDislike.title = "Iscriviti al forum per poter votare questo consiglio";
    }

    postValutazione.appendChild(btnLike);
    postValutazione.appendChild(punteggioTotale);
    postValutazione.appendChild(btnDislike);

    const postAzioniDestra = document.createElement("div");
    postAzioniDestra.className = "post-azioni-destra";

    let adminSegnalazioniCount = null;
    let btnSegnala = null;

    // per l'admin, nel caso un post abbia 5 segnalazioni non viene mostrato il bottone "segnala"
    if (post.segnalazioni < 5) {
        btnSegnala = document.createElement("button");
        btnSegnala.type = "button";
        btnSegnala.className = "btn-segnala " + classeSegnala;
        btnSegnala.textContent = "⚠️";
        // il tasto di segnalazione è attivo solo per utenti iscritti
        if (STATO_FORUM.isIscritto) { 
            btnSegnala.title = "Segnala Post";
            btnSegnala.addEventListener("click", function() {
                segnalaPost(post.id_post, btnSegnala, adminSegnalazioniCount);
            });
        } else {
            btnSegnala.disabled = true;
            btnSegnala.title = "Iscriviti al forum per poter segnalare questo consiglio";
        }
        postAzioniDestra.appendChild(btnSegnala);
    }

    // bottoni per funzionalità amministratore
    if (STATO_FORUM.isAdmin) {
        adminSegnalazioniCount = document.createElement("span");
        adminSegnalazioniCount.className = "admin-segnalazioni-count";
        adminSegnalazioniCount.title = "Numero di segnalazioni attuali";
        adminSegnalazioniCount.textContent = "! " + (post.segnalazioni ? post.segnalazioni : 0);

        const btnElimina = document.createElement("button");
        btnElimina.type = "button";
        btnElimina.className = "btn-admin btn-elimina";
        btnElimina.title = "Elimina Post";
        btnElimina.textContent = "🗑️";
        btnElimina.addEventListener("click", function() {
            if (confirm("Sei sicuro di voler eliminare definitivamente questo consiglio?")) {
                eliminaPost(post.id_post, article);
            }
        });

        const btnModifica = document.createElement("button");
        btnModifica.type = "button";
        btnModifica.className = "btn-admin btn-modifica";
        btnModifica.title = "Modifica Post";
        btnModifica.textContent = "✏️";
        btnModifica.addEventListener("click", function() {
            apriFormInModifica(post);
        });

        const btnRipristina = document.createElement("button");
        btnRipristina.type = "button";
        btnRipristina.className = "btn-admin btn-ripristina";
        btnRipristina.title = "Ripristina contatore segnalazioni";
        btnRipristina.textContent = "🔄";
        btnRipristina.addEventListener("click", function() {
            ripristinaSegnalazioni(post.id_post, adminSegnalazioniCount, btnSegnala);
        });

        postAzioniDestra.appendChild(adminSegnalazioniCount);
        postAzioniDestra.appendChild(btnElimina);
        postAzioniDestra.appendChild(btnModifica);
        postAzioniDestra.appendChild(btnRipristina);
    }

    //etichetta che indica se il post sia stato modificato dall'admin
    if (post.modificato === 1) {
        const etichettaModificato = document.createElement("span");
        etichettaModificato.className = "etichetta-modificato";
        etichettaModificato.textContent = "modificato";
        postAzioniDestra.appendChild(etichettaModificato);
    }

    postFooter.appendChild(postValutazione);
    postFooter.appendChild(postAzioniDestra);

    article.appendChild(postHeader);
    article.appendChild(postContenuto);
    article.appendChild(postTopicTags);
    article.appendChild(postFooter);

    return article;
}

// funzione che usa la precedente per stampare i post a partire dall'elenco ricevuto dal server o dall'array locale
function renderizzaPost(listaPost) {
    feedCentrale.innerHTML = "";

    if (!listaPost || listaPost.length === 0) {
        const avviso = document.createElement("p");
        avviso.className = "messaggio-vuoto";
        avviso.textContent = "Nessun post presente in questo forum.";
        feedCentrale.appendChild(avviso);
        return;
    }

    listaPost.forEach(function(post) {
        const scheda = schedaPost(post);
        feedCentrale.appendChild(scheda);
    });
}

// funzione che scrive e aggiorna in locale le statistiche del forum
function aggiornaStatistiche() {
    spanTitolo.textContent = "\u00A0\u00A0>>>\u00A0\u00A0" + STATO_FORUM.nomeForum;
    linkAdmin.textContent = STATO_FORUM.nomeAdmin;
    linkAdmin.href = `profilo.php?utente=${STATO_FORUM.nomeAdmin}`;
    spanIscritti.textContent = STATO_FORUM.totaleIscritti;
    spanPost.textContent = STATO_FORUM.totalePost;
}

// modifica l'interfaccia per gli utenti iscritti
function aggiornaPermessi() {
    areaPulsanti.innerHTML = "";
    const bottoneAzione = document.createElement("button");
    bottoneAzione.type = "button";

    if (STATO_FORUM.isIscritto) {
        bottoneAzione.id = "btn-posta";
        bottoneAzione.textContent = "Nuovo post";
        
        bottoneAzione.addEventListener("click", function() {
            idPostInModifica = null;
            titoloFormDestro.textContent = "Crea un nuovo post";
            btnInviaFormDestro.textContent = "Pubblica post";
            formNuovoPost.reset();
            errInvioPost.innerHTML = "&nbsp;";

            boxDestra.classList.remove("chiuso");
            feedCentrale.classList.add("menu-aperto");
            this.disabled = true;
        });
    } else {
        bottoneAzione.id = "btn-iscriviti";
        bottoneAzione.textContent = "Iscriviti";
        bottoneAzione.addEventListener("click", function() {
            iscrizioneForum();
        });
    }
    areaPulsanti.appendChild(bottoneAzione);

    if (STATO_FORUM.isAdmin) {
        menuAmministrazione.classList.remove("nascosto");
    } else {
        menuAmministrazione.classList.add("nascosto");
    }
}

// funzione che stampa e aggiorna l'elenco dei topic nelle checklist
function stampaTopic() {
    if (!topicFiltri || !topicCreazione) return;

    topicFiltri.innerHTML = "";
    topicCreazione.innerHTML = "";

    if (!STATO_FORUM.topics || STATO_FORUM.topics.length === 0) {
        const avvisoFiltri = document.createElement("p");
        avvisoFiltri.className = "messaggio-vuoto";
        avvisoFiltri.textContent = "Nessun topic per questo forum";

        const avvisoCreazione = document.createElement("p");
        avvisoCreazione.className = "messaggio-vuoto";
        avvisoCreazione.textContent = "Nessun topic per questo forum";

        topicFiltri.appendChild(avvisoFiltri);
        topicCreazione.appendChild(avvisoCreazione);
        return;
    }

    STATO_FORUM.topics.forEach(function(topic) {
        const labelFiltro = document.createElement("label");
        const inputFiltro = document.createElement("input");
        inputFiltro.type = "checkbox";
        inputFiltro.name = "topic_filtro[]";
        inputFiltro.value = topic.titolo_topic; 
        
        labelFiltro.appendChild(inputFiltro);
        labelFiltro.appendChild(document.createTextNode("#" + topic.titolo_topic));
        topicFiltri.appendChild(labelFiltro);

        const labelCreazione = document.createElement("label");
        const inputCreazione = document.createElement("input");
        inputCreazione.type = "checkbox";
        inputCreazione.name = "tag_post[]";
        inputCreazione.value = topic.id_topic; 
        
        labelCreazione.appendChild(inputCreazione);
        labelCreazione.appendChild(document.createTextNode("#" + topic.titolo_topic));
        topicCreazione.appendChild(labelCreazione);
    });

    inizializzaCheckPost();
    inizializzaCheckFiltri();
}

// inizializza le checkbox per il pannello di creazione/modifica
function inizializzaCheckPost() {
    const checkboxes = boxDestra.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener("change", function() {
            const spuntate = boxDestra.querySelectorAll('input[type="checkbox"]:checked');
            if (spuntate.length > 3) {
                this.checked = false;
                errInvioPost.textContent = "Massimo 3 topic consentiti.";
            } else {
                errInvioPost.innerHTML = "&nbsp;";
            }
        });
    });
}

// inizializza le checkbox per il pannello di filtraggio
function inizializzaCheckFiltri() {
    const checkboxes = topicFiltri.querySelectorAll('input[type="checkbox"]');
    const radioButtons = document.querySelectorAll('input[name="modalita_ricerca"]');

    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener("change", function() {
            const modalita = document.querySelector('input[name="modalita_ricerca"]:checked').value;
            if (modalita === "filtra") {
                const spuntate = topicFiltri.querySelectorAll('input[type="checkbox"]:checked');
                if (spuntate.length > 3) {
                    this.checked = false;
                    return;
                }
            }
            filtraPost();
        });
    });

    radioButtons.forEach(function(radio) {
        radio.addEventListener("change", function() {
            if (this.value === "filtra") {
                const spuntate = topicFiltri.querySelectorAll('input[type="checkbox"]:checked');
                if (spuntate.length > 3) {
                    for (let i = 3; i < spuntate.length; i++) spuntate[i].checked = false;
                }
            }
            filtraPost();
        });
    });
}

// filtraggio dei post
function filtraPost() {
    const checkboxSelezionate = topicFiltri.querySelectorAll('input[type="checkbox"]:checked');
    const topicScelti = Array.from(checkboxSelezionate).map(function(cb) { return cb.value; });

    if (topicScelti.length === 0) {
        renderizzaPost(STATO_FORUM.posts);
        return;
    }

    const modalita = document.querySelector('input[name="modalita_ricerca"]:checked').value;
    const postFiltrati = STATO_FORUM.posts.filter(function(post) {
        const tagPost = post.tags || [];
        if (modalita === "affianca") {
            //risultati "sommati"
            return topicScelti.some(function(topic) { return tagPost.includes(topic); });
        } else {
            //risultati "incrociati"
            return topicScelti.every(function(topic) { return tagPost.includes(topic); });
        }
    });

    renderizzaPost(postFiltrati);
}