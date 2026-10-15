function inizializza() {
    //si analizza la pagina di provenienza per gestire il link nel titolo
    const paginaPrecedente = document.referrer;
    let destinazioneLink = "../php/home.php"; // di base home

    // se l'utente proveniva da index.php
    if (paginaPrecedente === "" || !paginaPrecedente.includes("/php/")) {
        destinazioneLink = "../index.php"; 
    }

    generaHeader({
        guida: false, 
        profilo: false, 
        nomeUtente: null,
        linkDestinazione: destinazioneLink
    });
}

document.addEventListener("DOMContentLoaded", function() {
    inizializza();
});