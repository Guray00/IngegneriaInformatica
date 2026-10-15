/**
 * Genera e popola dinamicamente la struttura interna del dialog 
 * usando esclusivamente la manipolazione pura del DOM (No innerHTML).
 * @param {string} tipo - Può essere 'forum' oppure 'topic'
 */
 function generaDialog(tipo) {
    const dialog = document.getElementById("dialog-crea");
    if (!dialog) {
        alert("Impossibile generare il dialog: tag <dialog> non trovato nel DOM.");
        return;
    }

    while (dialog.firstChild) {
        dialog.removeChild(dialog.firstChild);
    }

    // 1. Configurazione dei nomi in base ai flag
    let testoTitolo = "";
    let testoLabel = "";
    let nomeInputName = "";

    if (tipo === 'forum') {
        testoTitolo = "Crea un nuovo forum";
        testoLabel = "Inserisci il nome del forum:";
        nomeInputName = "nome_forum";
    } else if (tipo === 'topic') {
        testoTitolo = "Crea un nuovo topic";
        testoLabel = "Inserisci il nome del topic:";
        nomeInputName = "nome_topic";
    } else {
        alert("Tipo di dialog non valido. Usa 'forum' o 'topic'.");
        return;
    }

    // 2. Costruzione della testata
    const divHeader = document.createElement("div");
    divHeader.className = "dialog-header";

    const h2 = document.createElement("h2");
    h2.textContent = testoTitolo;

    const btnChiudi = document.createElement("button");
    btnChiudi.type = "button";
    btnChiudi.id = "btn-chiudi-dialog";
    btnChiudi.textContent = "✕";

    divHeader.appendChild(h2);
    divHeader.appendChild(btnChiudi);

    // 3. Costruzione del form
    const form = document.createElement("form");
    form.id = "form-crea";

    const label = document.createElement("label");
    label.htmlFor = "nome-nuovo";
    label.textContent = testoLabel;

    const input = document.createElement("input");
    input.type = "text";
    input.id = "nome-nuovo";
    input.name = nomeInputName;
    input.placeholder = "Max 20 caratteri...";
    input.required = true;
    input.maxLength = 20;

    const spanErrore = document.createElement("span");
    spanErrore.id = "err-creazione";
    spanErrore.className = "errore";
    spanErrore.textContent = "\u00A0";

    const btnInvia = document.createElement("button");
    btnInvia.type = "submit";
    btnInvia.id = "btn-conferma-creazione";
    btnInvia.textContent = "Conferma e Crea";

    form.appendChild(label);
    form.appendChild(input);
    form.appendChild(spanErrore);
    form.appendChild(btnInvia);

    dialog.appendChild(divHeader);
    dialog.appendChild(form);
}