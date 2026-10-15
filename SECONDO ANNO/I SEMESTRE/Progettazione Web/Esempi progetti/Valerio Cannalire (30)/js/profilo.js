function caricaDatiProfilo() {
    const urlParams = new URLSearchParams(window.location.search);
    const utenteTarget = urlParams.get('utente');

    const datiInviare = new FormData();
    if (utenteTarget) {
        datiInviare.append("username_profilo", utenteTarget);
    }

    fetch("get_dati_profilo.php", {
        method: "POST",
        body: datiInviare
    })
    .then(function(risposta) {
        if (!risposta.ok) throw new Error("Risposta del server non valida.");
        return risposta.json();
    })
    .then(function(data) {
        if (data.error) {
            alert(data.error);
            window.location.href = "home.php"; // fallback di sicurezza in caso di utente inesistente
            return;
        }

        // icona profilo nell'header assente solo se il profilo è quello personale
        const mostraIconaProfilo = !data.is_proprio;

        generaHeader({
            guida: true,
            percorsoGuida: true,
            profilo: mostraIconaProfilo,
            nomeUtente: data.username_loggato, 
            linkDestinazione: "home.php"     
        });

        // nome dell'utente a fianco del titolo del sito
        const spanTitoloHeader = document.getElementById("nome-forum");
        spanTitoloHeader.textContent = "\u00A0\u00A0>>>\u00A0\u00A0@" + data.username_target;

        // statistiche
        document.getElementById("stat-post").textContent = data.statistiche.post_pubblicati;
        
        const bilancio = data.statistiche.bilancio_valutazioni;
        document.getElementById("stat-bilancio").textContent = bilancio >= 0 ? "+" + bilancio : bilancio;
        
        document.getElementById("stat-forum").textContent = data.statistiche.forum_iscritti;

        // tasto di logout nel caso il profilo sia quello personale
        const areaLogout = document.getElementById("area-pulsante-logout");
        areaLogout.innerHTML = "";

        if (data.is_proprio) {
            const bottoneLogout = document.createElement("button");
            bottoneLogout.type = "button";
            bottoneLogout.className = "btn-logout";
            bottoneLogout.textContent = "Disconnetti";
            
            bottoneLogout.addEventListener("click", function() {
                if (confirm("Vuoi davvero uscire dal sito?")) {
                    window.location.href = "logout.php";
                }
            });
            areaLogout.appendChild(bottoneLogout);
        }
    })
    .catch(function(errore) {
        alert("Errore nel caricamento del profilo:", errore);
    });
}

function inizializza() {
    caricaDatiProfilo();
}

document.addEventListener("DOMContentLoaded", function() {
    inizializza();
});