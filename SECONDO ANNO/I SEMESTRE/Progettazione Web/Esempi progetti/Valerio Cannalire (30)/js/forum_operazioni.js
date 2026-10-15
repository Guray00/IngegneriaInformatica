function iscrizioneForum() {
    const urlParams = new URLSearchParams(window.location.search);
    const idForum = urlParams.get('id');
    if (!idForum) return;

    const datiInviare = new FormData();
    datiInviare.append("id_forum", idForum);

    fetch("iscrizione.php", { method: "POST", body: datiInviare })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.text();
    })
    .then(function(messaggio) {
        if (messaggio.trim() === "OK") {
            STATO_FORUM.isIscritto = true;
            STATO_FORUM.totaleIscritti = STATO_FORUM.totaleIscritti + 1;
            alert("Ti sei iscritto con successo al forum! 🎉");
            aggiornaStatistiche();
            aggiornaPermessi();
            renderizzaPost(STATO_FORUM.posts);
        } else {
            alert(messaggio);
        }
    })
    .catch(function() {
        alert("Errore di connessione: impossibile completare l'iscrizione.");
    });
}

function creaTopic(idForum) {
    const datiForm = new FormData(formCreazioneTopic);
    datiForm.append("id_forum", idForum);

    fetch("crea_topic.php", { method: "POST", body: datiForm })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.text();
    })
    .then(function(messaggio) {
        if (!isNaN(messaggio) && messaggio.trim() !== "") {
            const idTopic = parseInt(messaggio, 10);
            const contenutoOriginale = Array.from(formCreazioneTopic.children);
            formCreazioneTopic.innerHTML = "";

            const testoSuccesso = document.createElement("p");
            testoSuccesso.className = "overlay-successo";
            testoSuccesso.textContent = "Topic creato con successo! 🚀";
            formCreazioneTopic.appendChild(testoSuccesso);

            const nuovoTitoloClean = inputCreazioneTopic.value.trim();
            
            if (!STATO_FORUM.topics) STATO_FORUM.topics = [];
            
            // aggiornamento locale con id restituito dal server
            STATO_FORUM.topics.push({
                id_topic: idTopic,
                titolo_topic: nuovoTitoloClean
            });

            // aggiornamento checkbox
            stampaTopic();

            setTimeout(function() {
                dialogTopic.open = false;
                overlay.classList.add("nascosto");
                formCreazioneTopic.innerHTML = "";
                contenutoOriginale.forEach(function(figlio) {
                    formCreazioneTopic.appendChild(figlio);
                });
                formCreazioneTopic.reset();
            }, 2000);
        } else {
            errCreazioneTopic.textContent = messaggio; 
        }
    })
    .catch(function() {
        errCreazioneTopic.textContent = "Errore di connessione o operazione non consentita.";
    });
}

function pubblicaPost(idForum) {
    const datiForm = new FormData(formNuovoPost);
    datiForm.append("id_forum", idForum);

    fetch("crea_post.php", { method: "POST", body: datiForm })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.text();
    })
    .then(function(messaggio) {
        if (!isNaN(messaggio) && messaggio.trim() !== "") {
            const idNuovoPost = parseInt(messaggio, 10);

            //stampa locale del post, senza ricaricare intera pagina
            // 1. recupero dei topic spuntati
            const checkboxSpuntate = topicCreazione.querySelectorAll('input[type="checkbox"]:checked');
            const tagTestualiscelti = Array.from(checkboxSpuntate).map(function(checkbox) {
                const topicTrovato = STATO_FORUM.topics.find(t => t.id_topic == checkbox.value);
                return topicTrovato ? topicTrovato.titolo_topic : "";
            }).filter(titolo => titolo !== "");

            // 2. stringa oraria
            const oggi = new Date();
            const dataFormattata = oggi.toISOString().slice(0, 10) + " " + oggi.toTimeString().slice(0, 5);

            // 3. username
            let usernameLoggato;
            const linkMioProfiloHeader = document.querySelector("header .profilo a");
            usernameLoggato = linkMioProfiloHeader.textContent.trim();

            // 4. contenuti, interazioni azzerate e assemblaggio
            const oggettoNuovoPost = {
                id_post: idNuovoPost,
                autore: usernameLoggato, 
                titolo: document.getElementById("titolo-post").value.trim(),
                contenuto: document.getElementById("testo-post").value.trim(),
                data: dataFormattata,
                modificato: 0,
                likes: 0,       
                dislikes: 0,     // inseriti per parità strutturale con get_dati_forum.php (funzionalità future)
                segnalato_da_me: 0,
                segnalazioni: 0,
                ranking: 0,
                tags: tagTestualiscelti,
                mia_interazione: null
            };

            const contenutoOriginale = Array.from(formNuovoPost.children);
            formNuovoPost.innerHTML = "";

            const testoSuccesso = document.createElement("p");
            testoSuccesso.className = "overlay-successo";
            testoSuccesso.textContent = "Post pubblicato con successo! 📝🎉";
            formNuovoPost.appendChild(testoSuccesso);

            // 5. inserimento del post nell'array locale
            if (!STATO_FORUM.posts) STATO_FORUM.posts = [];
            STATO_FORUM.posts.push(oggettoNuovoPost);

            // 6. sorting
            STATO_FORUM.posts.sort(function(a, b) {
                return b.ranking - a.ranking;
            });

            // 7. aggiornamento locale delle statistiche del forum
            STATO_FORUM.totalePost = STATO_FORUM.totalePost + 1;
            aggiornaStatistiche();

            renderizzaPost(STATO_FORUM.posts);

            setTimeout(function() {
                boxDestra.classList.add("chiuso");
                feedCentrale.classList.remove("menu-aperto");
                const btnPosta = document.getElementById("btn-posta");
                btnPosta.disabled = false;
                
                formNuovoPost.innerHTML = "";
                contenutoOriginale.forEach(function(figlio) { formNuovoPost.appendChild(figlio); });
                formNuovoPost.reset();
            }, 2000);
        } else {
            errInvioPost.textContent = messaggio;
        }
    })
    .catch(function() {
        errInvioPost.textContent = "Errore di connessione o operazione non consentita.";
    });
}

function eliminaPost(idPost, nodoArticolo) {
    const datiInviare = new FormData();
    datiInviare.append("id_post", idPost);

    fetch("elimina.php", { method: "POST", body: datiInviare })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            return;
        }
        if (data.status === "OK") {
            STATO_FORUM.posts = STATO_FORUM.posts.filter(function(p) { return p.id_post !== idPost; });
            STATO_FORUM.totalePost = Math.max(0, STATO_FORUM.totalePost - 1);
            aggiornaStatistiche();
            nodoArticolo.remove();

            if (STATO_FORUM.posts.length === 0) renderizzaPost([]);
        }
    })
    .catch(function() {
        alert("Errore di connessione: impossibile eliminare il post.");
    });
}

function apriFormInModifica(post) {
    idPostInModifica = post.id_post;

    if (post.segnalazioni >= 5) {
        // modifica e ripristino per post segnalati 5 volte
        titoloFormDestro.textContent = "Modifica e Ripristina Post";
        btnInviaFormDestro.textContent = "Salva e Ripristina";
    } else {
        // modifica
        titoloFormDestro.textContent = "Modifica il Post";
        btnInviaFormDestro.textContent = "Salva Modifiche";
    }

    document.getElementById("titolo-post").value = post.titolo;
    document.getElementById("testo-post").value = post.contenuto;

    // checkbox riempite con i topic del post
    const checkboxes = topicCreazione.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(function(checkbox) {
        const topicTrovato = STATO_FORUM.topics.find(t => t.id_topic == checkbox.value);
        checkbox.checked = topicTrovato ? post.tags.includes(topicTrovato.titolo_topic) : false;
    });

    errInvioPost.innerHTML = "&nbsp;";

    boxDestra.classList.remove("chiuso");
    feedCentrale.classList.add("menu-aperto");
    
    const btnPosta = document.getElementById("btn-posta");
    btnPosta.disabled = true;
}

function salvaModificaPost(idForum) {
    const datiForm = new FormData(formNuovoPost);
    datiForm.append("id_post", idPostInModifica);

    fetch("modifica_post.php", { method: "POST", body: datiForm })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            errInvioPost.textContent = data.error;
            return;
        }

        if (data.status === "OK") {
            const contenutoOriginale = Array.from(formNuovoPost.children);
            formNuovoPost.innerHTML = "";

            const testoSuccesso = document.createElement("p");
            testoSuccesso.className = "overlay-successo";
            testoSuccesso.textContent = "Modifiche salvate con successo! ✏️🚀";
            formNuovoPost.appendChild(testoSuccesso);

            // ripristino segnalazioni per post con 5 segnalazioni
            const postInOggetto = STATO_FORUM.posts.find(function(p) { return p.id_post === idPostInModifica; });
            
            if (postInOggetto && postInOggetto.segnalazioni >= 5) {
                const datiReset = new FormData();
                datiReset.append("id_post", idPostInModifica);
                
                fetch("ripristina.php", { method: "POST", body: datiReset })
                .then(function() {
                    caricaDatiForum(idForum);
                });
            } else {
                caricaDatiForum(idForum);
            }

            setTimeout(function() {
                //reset
                boxDestra.classList.add("chiuso");
                feedCentrale.classList.remove("menu-aperto");
                
                const btnPosta = document.getElementById("btn-posta");
                btnPosta.disabled = false;

                idPostInModifica = null;
                titoloFormDestro.textContent = "Crea un nuovo Post";
                btnInviaFormDestro.textContent = "Pubblica Post";

                formNuovoPost.innerHTML = "";
                contenutoOriginale.forEach(function(figlio) { formNuovoPost.appendChild(figlio); });
                formNuovoPost.reset();
            }, 2000);
        }
    })
    .catch(function() {
        errInvioPost.textContent = "Errore di connessione: impossibile salvare le modifiche.";
    });
}

function votaPost(idPost, tipoVoto, nodoLike, nodoDislike, nodoRanking) {
    const datiInviare = new FormData();
    datiInviare.append("id_post", idPost);
    datiInviare.append("tipo_voto", tipoVoto);

    fetch("vota.php", { method: "POST", body: datiInviare })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            return;
        }

        // aggiornamento locale interazione e ranking
        nodoLike.classList.remove("voto-attivo");
        nodoDislike.classList.remove("voto-attivo");

        if (data.mia_interazione === 'like') {
            nodoLike.classList.add("voto-attivo");
        } else if (data.mia_interazione === 'dislike') {
            nodoDislike.classList.add("voto-attivo");
        }

        const r = data.nuovo_ranking;
        nodoRanking.textContent = r >= 0 ? "+" + r : r;

        const postTrovato = STATO_FORUM.posts.find(function(p) { return p.id_post === idPost; });
        if (postTrovato) {
            postTrovato.ranking = r;
            postTrovato.mia_interazione = data.mia_interazione;
        }
    })
    .catch(function() {
        alert("Errore di connessione: impossibile registrare il tuo voto.");
    });
}

function segnalaPost(idPost, nodoSegnala, nodoContatoreAdmin) {
    const datiInviare = new FormData();
    datiInviare.append("id_post", idPost);
    
    //serve per non creare inconsistenze quando l'admin ripristina le segnalazioni se un altro utente ha una sessione aperta
    const haClasseAttiva = nodoSegnala.classList.contains("segnala-attivo");
    datiInviare.append("stato_corrente_client", haClasseAttiva ? "attivo" : "inattivo");

    fetch("segnala.php", { method: "POST", body: datiInviare })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            return;
        }

        if (data.mia_interazione === 'segnala') {
            nodoSegnala.classList.add("segnala-attivo");
        } else {
            nodoSegnala.classList.remove("segnala-attivo");
        }

        if (nodoContatoreAdmin !== null) {
            nodoContatoreAdmin.textContent = "! " + data.totale_segnalazioni;
        }

        const postTrovato = STATO_FORUM.posts.find(function(p) { return p.id_post === idPost; });
        if (postTrovato) {
            postTrovato.segnalazioni = data.totale_segnalazioni;
        }
    })
    .catch(function() {
        alert("Errore di connessione: impossibile completare l'operazione di segnalazione.");
    });
}

//permette all'admin di ripristinare le segnalazioni di un post
function ripristinaSegnalazioni(idPost, nodoContatoreAdmin, nodoSegnala) {
    const datiInviare = new FormData();
    datiInviare.append("id_post", idPost);

    fetch("ripristina.php", { method: "POST", body: datiInviare })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error();
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            return;
        }

        if (data.status === "OK") {
            const postTrovato = STATO_FORUM.posts.find(function(p) { return p.id_post === idPost; });
            if (postTrovato) {
                postTrovato.segnalazioni = 0;
                if (postTrovato.segnalato_da_me === 1) postTrovato.segnalato_da_me = 0;
            }

            if (nodoContatoreAdmin) nodoContatoreAdmin.textContent = "! 0";
            if (nodoSegnala) nodoSegnala.classList.remove("segnala-attivo");

            const urlParams = new URLSearchParams(window.location.search);
            caricaDatiForum(urlParams.get('id'));
            alert("Segnalazioni azzerate con successo per questo post! 🔄");
        }
    })
    .catch(function() {
        alert("Errore di connessione: impossibile azzerare le segnalazioni.");
    });
}

