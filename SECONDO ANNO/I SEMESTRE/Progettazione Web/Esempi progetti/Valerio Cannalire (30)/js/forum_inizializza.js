// funzione che esegue il caricamento iniziale dei dati dal forum
function caricaDatiForum(idForum) {
    const datiInviare = { id_forum: idForum };

    fetch("get_dati_forum.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(datiInviare)
    })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error("Il server ha risposto con status " + risposta.status);
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            return;
        }

        STATO_FORUM.isAdmin = data.is_admin;
        STATO_FORUM.nomeAdmin = data.nome_admin;
        STATO_FORUM.nomeForum = data.nome_forum;
        STATO_FORUM.isIscritto = data.is_iscritto;
        STATO_FORUM.totaleIscritti = data.totale_iscritti;
        STATO_FORUM.totalePost = data.totale_post;
        STATO_FORUM.topics = data.topics;
        STATO_FORUM.posts = data.posts;

        generaHeader({
            guida: true,
            percorsoGuida: true, 
            profilo: true,
            nomeUtente: data.username_loggato, 
            linkDestinazione: "home.php"       
        });

        spanTitolo = document.getElementById("nome-forum");
        document.title = "Consigli Non Richiesti > " + STATO_FORUM.nomeForum;
        aggiornaStatistiche();
        aggiornaPermessi();
        stampaTopic();
        renderizzaPost(STATO_FORUM.posts);
    })
    .catch(function(error) {
        alert("Errore AJAX durante il bootstrap iniziale del forum:", error);
    });
}

function inizializza() {
    feedCentrale = document.getElementById("feed");
    boxDestra = document.getElementById("box-creazione-post");
    formNuovoPost = document.getElementById("form-nuovo-post");
    btnChiudiDestra = document.getElementById("btn-chiudi-scrittura");
    errInvioPost = document.getElementById("err-invio-post");

    areaPulsanti = document.getElementById("area-pulsanti");
    menuAmministrazione = document.getElementById("menu-amministrazione");

    titoloFormDestro = boxDestra.querySelector(".header-creazione h2");
    btnInviaFormDestro = document.getElementById("btn-invia-post");

    topicFiltri = document.getElementById("topic-filtri");
    topicCreazione = document.getElementById("topic-creazione");

    overlay = document.getElementById("dialog-overlay");
    dialogTopic = document.getElementById("dialog-crea");
    generaDialog("topic");
    btnApriTopic = document.getElementById("btn-nuovo-topic"); 
    btnChiudiTopic = document.getElementById("btn-chiudi-dialog");
    formCreazioneTopic = document.getElementById("form-crea");
    errCreazioneTopic = document.getElementById("err-creazione");
    inputCreazioneTopic = document.getElementById("nome-nuovo");
    
    spanTitolo = document.getElementById("nome-forum");
    linkAdmin = document.getElementById("stat-admin"); 
    spanIscritti = document.getElementById("stat-iscritti");
    spanPost = document.getElementById("stat-post");

    const urlParams = new URLSearchParams(window.location.search);
    const idForum = urlParams.get('id');

    if (!idForum) {
        alert("ID Forum mancante nella query string dell'URL");
        return;
    }

    btnChiudiDestra.addEventListener("click", function() {
        boxDestra.classList.add("chiuso");
        feedCentrale.classList.remove("menu-aperto");
        const btnPosta = document.getElementById("btn-posta");
        if (btnPosta) btnPosta.disabled = false;
        formNuovoPost.reset();
    });

    btnApriTopic.addEventListener("click", function() {
        errCreazioneTopic.innerHTML = "&nbsp;"; 
        formCreazioneTopic.reset();
        dialogTopic.open = true;
        overlay.classList.remove("nascosto");
    });

    btnChiudiTopic.addEventListener("click", function() {
        dialogTopic.open = false;
        overlay.classList.add("nascosto");
    });

    inputCreazioneTopic.addEventListener("input", function() {
        errCreazioneTopic.innerHTML = "&nbsp;";
    });

    formCreazioneTopic.addEventListener("submit", function(event) {
        event.preventDefault(); 
        creaTopic(idForum);
    });

    formNuovoPost.addEventListener("submit", function(event) {
        event.preventDefault(); 
        if (idPostInModifica !== null) {
            salvaModificaPost(idForum);
        } else {
            pubblicaPost(idForum);
        }
    });

    formNuovoPost.addEventListener("input", function() {
        if (errInvioPost && errInvioPost.textContent !== "Massimo 3 topic consentiti.") {
            errInvioPost.innerHTML = "&nbsp;";
        }
    });

    caricaDatiForum(idForum);
}

document.addEventListener("DOMContentLoaded", function() {
    inizializza();
});