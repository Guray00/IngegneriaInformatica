var ComuniTotali = [];
var ComuniAgenzia = [];
var ComuniTotaliMetch = [];
var ComuniAgenziaMetch = [];

var AnnunciRicerca = [];
var IndiceRicerca = 0;

var NO_FOTO = "./foto/foto-annunci/no-foto.jpg";

/*
Vengono caricati tutti i comuni che abbiamo sul database e sappiamo anche se l'agenzia
ha almeno un annuncio in per ogni comune
*/
document.addEventListener("DOMContentLoaded", function() {
  let location = window.location.href;
  let agenzia = location.substring(location.indexOf("=")+1);

  var x = new XMLHttpRequest();
  var url = "./ajax/ajax-response.php";
  var vars = "id=3&a="+agenzia;
  x.open("POST", url, true);
  x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  x.onreadystatechange = function() {
    if(x.readyState == 4 && x.status == 200) {
        var data = x.responseText;
        ComuniTotali = JSON.parse(data);
        for(let i=0; i<ComuniTotali.length; i++){
            if(ComuniTotali[i].InAgenzia == 1) ComuniAgenzia.push(ComuniTotali[i]);
        }
    }
  }
  x.send(vars);
});

document.addEventListener("click", function(e) {
    if(e.target.id != "comuni-possibili" && e.target.className != "comune-possibile"){
        document.querySelector("#comuni-possibili").style.display = "none";
    }
});

/*
Chiamata quando viene scritta una lettera sul campo del comune
*/
document.querySelector("#comune").addEventListener("keyup", function() {
    let input = document.querySelector("#comune").value;
    let ListaComuniDOM = document.querySelector("#comuni-possibili");
    input = input.trim().toLowerCase();

    if(input == undefined || input == "") {
        ListaComuniDOM.style.display = "none";
        return;
    };

    ComuniTotaliMetch = [];
    ComuniAgenziaMetch = [];
    ComuniTotali.forEach(function(Comune){
        // Si trova all'interno della stringa del comune, quindi si mette in lista
        if(Comune.Nome.indexOf(input) != -1){
            let Metch = {
                nome: Comune.Nome,
                provincia: Comune.Provincia,
                siglaProvincia: Comune.SiglaProvincia,
                rapporto: (Comune.Nome.length / input.length),
                primaOccorrenza: (Comune.Nome.indexOf(input))
            };

            ComuniTotaliMetch.push(Metch);
            if(Comune.InAgenzia == 1) ComuniAgenziaMetch.push(Metch);
        }
    });

    if(ComuniAgenziaMetch.length == 0){
        // Nessun annuncio dell'agenzia ha un comune che potrebbe essere cercato dall'utente
        if(input.length >= 3){
            // Allora mostra i comuni generali metchati
            ComuniTotaliMetch.sort(OrdinaComuni);
            CreaComuniSuggeriti(ComuniTotaliMetch, 0);
        } else {
            // Non mostrare nulla
            ListaComuniDOM.style.display = "none";
            return;
        }
    } else if(input.length >= 3) {
        // Ci sono comuni dell'agenzia che potrebbero essere stati cercati dall'utente
        ComuniAgenziaMetch.sort(OrdinaComuni);
        CreaComuniSuggeriti(ComuniAgenziaMetch, 1);
    } else {
        // Non mostrare nulla
        ListaComuniDOM.style.display = "none";
        return;
    }
});


// --------------------------- FUNZIONI LISTA COMUNI -----------------------------
function OrdinaComuni(a, b){
    if(a.primaOccorrenza == b.primaOccorrenza){
        return (a.rapporto - b.rapporto);
    } else {
        return (a.primaOccorrenza - b.primaOccorrenza);
    }
}

function CreaComuniSuggeriti(ArrayComuni, typeComuni, all = false){
    let ListaComuniDOM = document.querySelector("#comuni-possibili");
    if(ArrayComuni.length == 0) ListaComuniDOM.style.display = "none";
    else ListaComuniDOM.style.display = "block";

    let ChildListaComuniDOM = ListaComuniDOM.querySelectorAll("div");
    ChildListaComuniDOM.forEach(function(div){
        div.remove();
    });

    for(let i=0; i<ArrayComuni.length; i++){
        let ComuneDOM = document.createElement("div");
        ComuneDOM.innerHTML = ArrayComuni[i].nome + " ("+ArrayComuni[i].siglaProvincia + ")";
        ComuneDOM.id = ArrayComuni[i].nome;
        ComuneDOM.className = "comune-possibile";
        ComuneDOM.setAttribute("onclick", "CopiaComune(this)");
        ListaComuniDOM.appendChild(ComuneDOM);
        if(all != true && i == 10) break;
    }
    if(all == true || ArrayComuni.length <= 10) return;
    let AltriComuniDOM = document.createElement("div");
    AltriComuniDOM.innerHTML = "Mostra tutti.";
    AltriComuniDOM.style.textAlign = "center";
    AltriComuniDOM.className = "comune-possibile";
    AltriComuniDOM.setAttribute("onclick", "MostraTuttiComuni(this, "+typeComuni+")");
    ListaComuniDOM.appendChild(AltriComuniDOM);
}

function MostraTuttiComuni(target, typeComuni){
    target.remove();
    if(typeComuni == 0) CreaComuniSuggeriti(ComuniTotaliMetch, 0, true);
    else if(typeComuni == 1) CreaComuniSuggeriti(ComuniAgenziaMetch, 1, true);
}

function CopiaComune(target){
    document.querySelector("#comuni-possibili").style.display = "none";
    document.querySelector("#comune").value = target.id.charAt(0).toUpperCase() + target.id.slice(1);
}

// -------------------------------------------------------------------------------


// Quando viene cliccato invio sul tasto per il cerca, allora si esegue la form
function PremiInvio(event){
    if(event.key === "Enter") EseguiForm();
}

function EseguiForm() {
    document.querySelector("#loading").style.display = "block";

    let error = document.getElementsByClassName("error")[0];
    let warning = document.getElementsByClassName("warning")[0];
    error.display = "none";
    warning.display = "none";
    error.innerHTML = "";
    warning.innerHTML = "";

    let comune = document.querySelector("#comune").value.toLowerCase();
    let ComuniTarget = "";
    let index = CercaNeiComuni(ComuniTotali, comune); // Si ottiene l'indice del comune, se esiste dentro l'array
    if(index != -1 && comune != "") {
        // Comune esistente in Italia
        if(CercaNeiComuni(ComuniAgenzia, comune) != -1) {
            // L'agenzia ha annunci in quel comune
            ComuniTarget = comune;
        } else {
            // L'agenzia non ha annunci in quel comune
            warning.innerHTML += "Nessun annuncio in questo comune.</br>";
            warning.display = "block";
            // Cercare nella provincia
            let provincia = ComuniTotali[index].Provincia;
            for(let i=0; i<ComuniAgenzia.length; i++){
                if(ComuniAgenzia[i].Provincia == provincia) ComuniTarget += (ComuniAgenzia[i].Nome + "£");
            }
            if(ComuniTarget == "") {
                // Visualizza errore (nessun annuncio manco dentro la provincia)
                warning.innerHTML += "Nessun annuncio in questa provincia.</br>";
                warning.display = "block";
                NascondiCaricamento();
                return;
            }
        }
    } else if(comune != ""){
        // Non esiste quel comune
        // Visualizza errore (comune non esistente o scritto male)
        error.innerHTML += "Nessun comune con questo nome.</br>";
        error.display = "block";
        NascondiCaricamento();
        return;
    }

    let contratto = document.querySelector("#tipo_contratto").value;
    let immobile = document.querySelector("#tipo_immobile").value;
    let prezzo_max = NormalizzaPrezzo(document.querySelector("#prezzo_max").value);
    let prezzo_min = NormalizzaPrezzo(document.querySelector("#prezzo_min").value);
    let prezzo_riservato = Boolean(document.querySelector("#riservato").checked);

    document.querySelector("#prezzo_max").value = prezzo_max;
    document.querySelector("#prezzo_min").value = prezzo_min;

    let location = window.location.href;
    let agenzia = location.substring(location.indexOf("=")+1);

    // Ajax
    var x = new XMLHttpRequest();
    var url = "./ajax/ajax-response.php";
    var vars = "id=4&a="+agenzia+"&com="+ComuniTarget+"&contr="+contratto+"&imm="+immobile+"&pmax="+prezzo_max+"&pmin="+prezzo_min+"&riservato="+prezzo_riservato;
    x.open("POST", url, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.onreadystatechange = function() {
      if(x.readyState == 4 && x.status == 200) {
        var data = x.responseText;
        AnnunciRicerca = JSON.parse(data.trim());
        IndiceRicerca = 0;
        if(AnnunciRicerca.length == 0) {
            if(warning.innerHTML == ""){
                warning.innerHTML = "Nessun annuncio che soddisfa la ricerca.</br>";
                warning.display = "block";
            }
        }
        VisulizzaAnnunci(true);
      }
    }
    x.send(vars);
    NascondiCaricamento();
}

function NormalizzaPrezzo(prezzo){
    // togliere ogni tipo di carattere non numerico
    if(/\D/.test(prezzo)){
        // Almeno un carattere non numerico
        if(/,/.test(prezzo) && /\./.test(prezzo)) {
            // Si trovano entrambi i caratteri
            // Rimarrà l'ultimo carattere tra i due trasformato in ,
            prezzo = TogliCaratteriNoUltimo(prezzo, ",");
            prezzo = TogliCaratteriNoUltimo(prezzo, ".");
            prezzo = prezzo.replace(/[\.,]/, "");
            prezzo = prezzo.replace(/[\.,]/, ",");
        } else if(/,/.test(prezzo)) {
            // Si trova solo la virgola tra i due
            // Lascia l'ultima occorrenza come ,
            prezzo = TogliCaratteriNoUltimo(prezzo, ",");
        } else if(/\./.test(prezzo)) {
            // Si trova solo il punto tra i due
            // Lascia l'ultima occorrenza come ,
            prezzo = TogliCaratteriNoUltimo(prezzo, ".");
            prezzo = prezzo.replace(/\./, ",");
        }
        prezzo = prezzo.replaceAll(/[a-z$%&£#@*\[\]]*/g, "");
        return prezzo;
    } else return prezzo;
}

function TogliCaratteriNoUltimo(stringa, c){
    let n = 0;
    for(let i=0; i<stringa.length; i++){
        if(stringa[i] == c) n++;
    }
    if(n <= 1) return stringa;
    for(let i=1; i<n; i++){
        stringa = stringa.replace(c, "");
    }
    return stringa;
}

function NascondiCaricamento(){
    setTimeout(function(){
        document.querySelector("#loading").style.display = "none";
    }, 200);
}

function CercaNeiComuni(array, valore){
    for(let i=0; i<array.length; i++){
        if(array[i].Nome == valore) return i;
    }
    return -1;
}

// Funzione per Visualizzare un numero stabilito di Annunci a volta
function VisulizzaAnnunci(Cancella = false){
    let Vetrina = document.querySelector("#blocco-vetrina");
    let ColoreAnnuncio = document.querySelector("#colore1").value;
    let AnnXPagina = (parseInt)(document.querySelector("#limite-annunci").value);

    if(Cancella){
        IndiceRicerca = 0;
        let AnnunciDOM = Vetrina.querySelectorAll("div");
        AnnunciDOM.forEach(function(AnnuncioDOM){
            AnnuncioDOM.remove();
        });
    } else {
        IndiceRicerca = (parseInt)(IndiceRicerca + AnnXPagina);
        let MostraAltroDOM = Vetrina.querySelector("#mostra-altro");
        MostraAltroDOM.remove();
    }

    // Creiamo attraverso JS l'annuncio
    for(let i=IndiceRicerca; i<((parseInt)(IndiceRicerca)+(parseInt)(AnnXPagina)); i++){
        if(AnnunciRicerca.length <= i) return;
        // Creazione Blocco che contiene l'annuncio
        let ContainerDOM = document.createElement("div");
        ContainerDOM.style.backgroundImage = "-webkit-linear-gradient(left, #F0F0F0 0%, "+ColoreAnnuncio+" 200%)";
        Vetrina.appendChild(ContainerDOM);

        // Inserimento  foto annuncio
        let ImmagineDOM = document.createElement("div");
        ImmagineDOM.id = AnnunciRicerca[i]["\u0000Annuncio\u0000IdAnnuncio"];
        ImmagineDOM.setAttribute("onclick", "PaginaAnnuncio(this)");
        ImmagineDOM.className = "fotografia";
        if(AnnunciRicerca[i]["Foto"] != undefined){
            ImmagineDOM.style.backgroundImage = "url("+AnnunciRicerca[i]["Foto"][0]+")";
        } else {
            ImmagineDOM.style.backgroundImage = "url("+NO_FOTO+")";
        }
        ContainerDOM.appendChild(ImmagineDOM);

        // Inserimento Provincia
        let ProvinciaDOM = document.createElement("div");
        ProvinciaDOM.className = "casella-testo-doppia";
        ProvinciaDOM.innerHTML = AnnunciRicerca[i]["\u0000Annuncio\u0000Comune"]+" ("+AnnunciRicerca[i]["\u0000Annuncio\u0000SiglaProvincia"]+")";
        ContainerDOM.appendChild(ProvinciaDOM);

        // Inserimento Categoria
        let CategoriaDOM = document.createElement("div");
        CategoriaDOM.className = "casella-testo-semplice";
        CategoriaDOM.innerHTML = AnnunciRicerca[i]["\u0000Annuncio\u0000Categoria"];
        ContainerDOM.appendChild(CategoriaDOM);

        // Inserimento Descrizione
        let DescrizioneDOM = document.createElement("div");
        DescrizioneDOM.className = "casella-descrizione";
        DescrizioneDOM.innerHTML = "<i>[Rif: "+AnnunciRicerca[i]["\u0000Annuncio\u0000Rif"]+"]</i></br>";
        DescrizioneDOM.innerHTML += AnnunciRicerca[i]["\u0000Annuncio\u0000Descrizione"];
        ContainerDOM.appendChild(DescrizioneDOM);

        // Inserimento Contratto
        let ContrattoDOM = document.createElement("div");
        ContrattoDOM.className = "casella-testo-semplice";
        ContrattoDOM.innerHTML = AnnunciRicerca[i]["\u0000Annuncio\u0000Contratto"];
        ContainerDOM.appendChild(ContrattoDOM);

        // Inserimento Prezzo
        let PrezzoDOM = document.createElement("div");
        PrezzoDOM.className = "prezzo-annuncio";
        PrezzoDOM.innerHTML = AnnunciRicerca[i]["\u0000Annuncio\u0000Prezzo"];
        ContainerDOM.appendChild(PrezzoDOM);
    }

    let MostraAltroDOM = document.createElement("div");
    MostraAltroDOM.id = "mostra-altro";
    MostraAltroDOM.setAttribute("onclick", "VisulizzaAnnunci();");
    MostraAltroDOM.innerHTML = "Mostra altro";
    Vetrina.appendChild(MostraAltroDOM);
}

function precedente(){
    indice = document.querySelector("#pagina").value;
    indice --;
    document.querySelector("#pagina").value = indice;
    document.querySelector("#form_annunci").submit();
}

function successivo(){
    indice = document.querySelector("#pagina").value;
    indice ++;
    document.querySelector("#pagina").value = indice;
    document.querySelector("#form_annunci").submit();
}

function VisualizzaErrore(strErrore){
    document.getElementsByClassName("error")[0].innerHTML = strErrore;
}

function VisualizzaWarning(strWarning){
    document.getElementsByClassName("warning")[0].innerHTML = strWarning;
}

function PaginaAnnuncio(ann){
    let url = window.location.href;
    url = url.substring(0, url.lastIndexOf("/"))+"/annuncio.php?a="+ann.id;
    window.open(url);
}
