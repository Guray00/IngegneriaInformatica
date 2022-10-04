var CampiDato;
var Annuncio;

function Esci(){
  var x = new XMLHttpRequest();
  var url = "./ajax/ajax-response.php";
  var vars = "id=11";
  x.open("POST", url, true);
  x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  x.onreadystatechange = function() {
    if(x.readyState == 4 && x.status == 200) {
      window.location.href = "./login.php";
    }
  }
  x.send(vars);
}

function SalvaImpostazioni(){
    let colore1 = document.querySelector("#colore1").value;
    let colore2 = document.querySelector("#colore2").value;
    let nomeAgenzia = document.querySelector("#agenzia_nome").value;
    var x = new XMLHttpRequest();
    var url = "./ajax/ajax-response.php";
    var vars = "id=2&colore1="+colore1+"&colore2="+colore2+"&nomeAgenzia="+nomeAgenzia;
    x.open("POST", url, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.onreadystatechange = function() {
      if(x.readyState == 4 && x.status == 200) {
        location.reload();
      }
    }
    x.send(vars);
}

function MostraNascondi(firstDOM, secondDOM){
    firstDOM = firstDOM + " .azione-click";
    let span_click = document.querySelector(firstDOM);
    let ImpostazioniSitoDOM = document.querySelector(secondDOM);
    if(ImpostazioniSitoDOM.style.display == "none" || span_click.innerHTML == "Mostra") {
        // Mostriamo
        span_click.innerHTML = "Nascondi";
        ImpostazioniSitoDOM.style.display = "block";
    } else {
        // Nascondiamo
        span_click.innerHTML = "Mostra";
        ImpostazioniSitoDOM.style.display = "none";
    }
}

function ModificaAnnuncio(){
  // Controllo se il riferimento esiste nel database per un annuncio dell'agenzia
  let rif = document.querySelector("#riferimento-input").value;
  document.querySelector("#rif").value = rif;
  var x = new XMLHttpRequest();
  var url = "./ajax/ajax-response.php";
  var vars = "id=6&rif="+rif;
  x.open("POST", url, true);
  x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  x.onreadystatechange = function() {
    if(x.readyState == 4 && x.status == 200) {
      var msg = x.responseText;
      if(msg == "NO"){
        document.querySelector("#error-rif").style.visibility = "visible";
      } else {
        Annuncio = JSON.parse(msg);
        document.querySelector("#error-rif").style.visibility = "hidden";
        document.querySelector("#sopra-annuncio h2").innerHTML = "Modifica l'annuncio.";
        document.querySelector("#scopo").value = "modifica";
        document.querySelector("#riferimento-vecchio").value = Annuncio["Rif"];
        document.querySelector("#id-annuncio").value = Annuncio["IdAnnuncio"];
        document.querySelector("#annuncio").style.display = "block";
        // Togli errori campi
        TogliStileErroriCampi();
        document.querySelector("#intestazione-foto-annuncio").style.display = "flex";
        document.querySelector("#campi-foto-annuncio").style.display = "none";
        SettaCampiCorrettamente(Annuncio);
        VisualizzaFoto(Annuncio["Foto"]);
      }
    }
  }
  x.send(vars);
}

function VisualizzaFoto(Foto){
  let FotoTutteDOM = document.querySelector("#foto-tutte");
  document.querySelectorAll("#foto-tutte .foto-singola").forEach(function(Foto){
    Foto.remove();
  });
  if(Foto == null) return;
  document.querySelector("#copertina").value = GetIdFotoFromLink(Foto[0]);
  let conto = 1;
  Foto.forEach(function(FotoSingola){
    let FotoSingolaDOM = document.createElement("div");
    FotoSingolaDOM.className = "foto-singola";
    FotoSingolaDOM.id = GetIdFotoFromLink(FotoSingola);
    FotoTutteDOM.appendChild(FotoSingolaDOM);
    let PulsantiDOM = document.createElement("div");
    PulsantiDOM.className = "pulsanti";
    FotoSingolaDOM.appendChild(PulsantiDOM);
    let StarDOM = document.createElement("i");
    let SquareDOM = document.createElement("i");
    StarDOM.className = "bi bi-star";
    StarDOM.setAttribute("onclick", "SetCopertina(this, "+conto+");");
    if(conto == 1) StarDOM.style.color = "orange";
    SquareDOM.className = "bi bi-x-square";
    SquareDOM.setAttribute("onclick", "RimuoviFoto(this, "+conto+");");
    PulsantiDOM.appendChild(StarDOM);
    PulsantiDOM.appendChild(SquareDOM);
    let ImageDOM = document.createElement("img");
    ImageDOM.setAttribute("src", FotoSingola);
    FotoSingolaDOM.appendChild(ImageDOM);
    conto ++;
  });
}
// Funzione chiamata per cambiare la copertina, e quindi l'ordine delle foto
function SetCopertina(target, posizione){
  if(target.style.color == "orange"){
    // Rimuovere dalla copertina
    target.style.color = "black";
    document.querySelector("#copertina").value;
  }
  else {
    let idFoto = target.parentElement.parentElement.id;
    let idAnnuncio = document.querySelector("#id-annuncio").value;
    // Mettere in copertina
    // Realizzare la parte di SQL
    var x = new XMLHttpRequest();
    var url = "./ajax/ajax-response.php";
    var vars = "id=9&idAnnuncio="+idAnnuncio+"&idFoto="+idFoto+"&posizione="+posizione;
    x.open("POST", url, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.onreadystatechange = function() {
      if(x.readyState == 4 && x.status == 200) {

      }
    }
    x.send(vars);
    let StarsDOM = document.querySelectorAll(".bi-star");
    StarsDOM.forEach(function(StarDOM){
      StarDOM.style.color = "black";
    });
    target.style.color = "orange";
    document.querySelector("#copertina").value = GetIdFotoFromLink(target.parentElement.parentElement.id);
  }
}

// Funzione usata per rimuovere la foto dall'annuncio
function RimuoviFoto(target, posizione){
  let idFoto = target.parentElement.parentElement.id;
  let idAnnuncio = document.querySelector("#id-annuncio").value;

  var x = new XMLHttpRequest();
  var url = "./ajax/ajax-response.php";
  var vars = "id=8&idAnnuncio="+idAnnuncio+"&idFoto="+idFoto+"&posizione="+posizione;
  x.open("POST", url, true);
  x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  x.onreadystatechange = function() {
    if(x.readyState == 4 && x.status == 200) {
      target.parentElement.parentElement.style.display = "none";
    }
  }
  x.send(vars);
}

function GetIdFotoFromLink(link){
  link = link.replace("./foto/foto-annunci/", "");
  link = link.replace(".jpg", "");
  return link;
}

function InserisciAnnuncio(){
  document.querySelector("#sopra-annuncio h2").innerHTML = "Crea l'annuncio.";
  document.querySelector("#scopo").value = "inserisci";
  document.querySelector("#annuncio").style.display = "block";
  // Togli errori campi
  document.querySelector("#intestazione-foto-annuncio").style.display = "none";
  document.querySelector("#campi-foto-annuncio").style.display = "none";
  TogliStileErroriCampi();
  AzzeraCampi();
}

// Funzione per salvare l'annuncio, gestisce sia i casi del nuovo annuncio, che quello della
// modifica
function SalvaAnnuncio(){
  let scopo = document.querySelector("#scopo").value;
  CampiDato = ControllaCampiObbligatori();
  if(scopo == "modifica"){
    // Modifica annuncio
    let RiferimentoVecchio = document.querySelector("#riferimento-vecchio").value;
    let IdAnnuncio = document.querySelector("#id-annuncio").value;
    if(CampiDato){
      document.querySelector("#errori").style.visibility = "hidden";
      var x = new XMLHttpRequest();
      var url = "./ajax/ajax-response.php";
      var vars = "id=7&IdAnnuncio="+IdAnnuncio+"&RiferimentoVecchio="+RiferimentoVecchio+"&Riferimento="+CampiDato.Riferimento;
      vars += "&Titolo="+CampiDato.Titolo+"&IdContratto="+CampiDato.IdContratto+"&IdCategoria="+CampiDato.IdCategoria;
      vars += "&Prezzo="+CampiDato.Prezzo+"&NumeroLocali="+CampiDato.NumeroLocali+"&Superficie="+CampiDato.Superficie;
      vars += "&Descrizione="+CampiDato.Descrizione+"&IdComune="+CampiDato.IdComune+"&Indirizzo="+CampiDato.Indirizzo;
      vars += "&Localita="+CampiDato.Indirizzo+"&IdClasseEnergetica="+CampiDato.IdClasseEnergetica+"&Ipe="+CampiDato.Ipe;
      vars += "&NumeroCamere="+CampiDato.NumeroCamere+"&Bagni="+CampiDato.Bagni+"&BoxAuto="+CampiDato.BoxAuto;
      vars += "&Balcone="+CampiDato.Balcone+"&Mansarda="+CampiDato.Mansarda+"&Cantina="+CampiDato.Cantina;
      vars += "&Arredato="+CampiDato.Arredato+"&Giardino="+CampiDato.Giardino+"&Ascensore="+CampiDato.Ascensore;
      x.open("POST", url, true);
      x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      x.onreadystatechange = function() {
        if(x.readyState == 4 && x.status == 200) {
          var msg = x.responseText;
          console.log(msg);
          if(msg != "OK"){
            document.querySelector("#errori").innerHTML = msg;
            document.querySelector("#errori").style.visibility = "visible";
          } else {
            document.querySelector("#errori").innerHTML = "Annuncio modificato!";
            document.querySelector("#errori").style.color = "green";
            document.querySelector("#errori").style.visibility = "visible";
            setTimeout(function(){
              document.querySelector("#errori").style.color = "red";
              document.querySelector("#errori").style.visibility = "hidden";
            }, 3000);
          }
        }
      }
      x.send(vars);
      if(document.querySelector("#prezzo").value == 0) document.querySelector("#prezzo").value = "Info in Agenzia";
    } else {
      // Errore presente
      document.querySelector("#errori").style.visibility = "visible";
      document.querySelector("#errori").innerHTML = "Errori presenti!";
      if(document.querySelector("#prezzo").value == 0) document.querySelector("#prezzo").value = "Info in Agenzia";
    }
  } else if(scopo == "inserisci"){
    // Inserisci nuovo annuncio
    if(CampiDato){
      document.querySelector("#errori").style.visibility = "hidden";
      var x = new XMLHttpRequest();
      var url = "./ajax/ajax-response.php";
      var vars = "id=5&Riferimento="+CampiDato.Riferimento;
      vars += "&Titolo="+CampiDato.Titolo+"&IdContratto="+CampiDato.IdContratto+"&IdCategoria="+CampiDato.IdCategoria;
      vars += "&Prezzo="+CampiDato.Prezzo+"&NumeroLocali="+CampiDato.NumeroLocali+"&Superficie="+CampiDato.Superficie;
      vars += "&Descrizione="+CampiDato.Descrizione+"&IdComune="+CampiDato.IdComune+"&Indirizzo="+CampiDato.Indirizzo;
      vars += "&Localita="+CampiDato.Indirizzo+"&IdClasseEnergetica="+CampiDato.IdClasseEnergetica+"&Ipe="+CampiDato.Ipe;
      vars += "&NumeroCamere="+CampiDato.NumeroCamere+"&Bagni="+CampiDato.Bagni+"&BoxAuto="+CampiDato.BoxAuto;
      vars += "&Balcone="+CampiDato.Balcone+"&Mansarda="+CampiDato.Mansarda+"&Cantina="+CampiDato.Cantina;
      vars += "&Arredato="+CampiDato.Arredato+"&Giardino="+CampiDato.Giardino+"&Ascensore="+CampiDato.Ascensore;
      x.open("POST", url, true);
      x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      x.onreadystatechange = function() {
        if(x.readyState == 4 && x.status == 200) {
          var msg = x.responseText;
          if(msg != "OK"){
            document.querySelector("#errori").innerHTML = msg;
            document.querySelector("#errori").style.visibility = "visible";
          } else {
            document.querySelector("#errori").innerHTML = "Nuovo annuncio inserito!";
            document.querySelector("#errori").style.color = "green";
            document.querySelector("#errori").style.visibility = "visible";
            setTimeout(function(){
              document.querySelector("#errori").style.color = "red";
              document.querySelector("#errori").style.visibility = "hidden";
            }, 3000);
          }
        }
      }
      x.send(vars);
      if(document.querySelector("#prezzo").value == 0) document.querySelector("#prezzo").value = "Info in Agenzia";
    } else {
      // Errore presente
      document.querySelector("#errori").style.visibility = "visible";
      document.querySelector("#errori").innerHTML = "Errori presenti!";
      if(document.querySelector("#prezzo").value == 0) document.querySelector("#prezzo").value = "Info in Agenzia";
    }
  }
}

function AzzeraCampi(){
  document.querySelector("#riferimento").value = "";
  document.querySelector("#titolo").value = "";
  document.querySelector("#contratto").value = "";
  document.querySelector("#categoria").value = "";
  document.querySelector("#prezzo").value = "";
  document.querySelector("#numero-locali").value = "";
  document.querySelector("#superficie").value = "";
  document.querySelector("#descrizione").value = "";
  document.querySelector("#comune").value = "";
  document.querySelector("#indirizzo").value = "";
  document.querySelector("#localita").value = "";
  document.querySelector("#classe-energetica").value = "";
  document.querySelector("#ipe").value = "";
  document.querySelector("#camere").value = "";
  document.querySelector("#bagni").value = "";
  document.querySelector("#box-auto").checked = 0;
  document.querySelector("#balcone").checked = 0;
  document.querySelector("#mansarda").checked = 0;
  document.querySelector("#cantina").checked = 0;
  document.querySelector("#arredato").checked = 0;
  document.querySelector("#giardino").checked = 0;
  document.querySelector("#ascensore").checked = 0;
}

function SettaCampiCorrettamente(){
  document.querySelector("#riferimento").value = Annuncio["Rif"];
  document.querySelector("#titolo").value = Annuncio["Titolo"],
  document.querySelector("#contratto").value = Annuncio["IdContratto"];
  document.querySelector("#categoria").value = Annuncio["IdCategoria"];
  document.querySelector("#prezzo").value = Annuncio["Prezzo"];
  document.querySelector("#numero-locali").value = Annuncio["NumeroLocali"];
  document.querySelector("#superficie").value = Annuncio["MetriQuadri"];
  document.querySelector("#descrizione").value = Annuncio["Descrizione"];
  document.querySelector("#comune").value = Annuncio["IdComune"];
  document.querySelector("#indirizzo").value = Annuncio["Indirizzo"];
  document.querySelector("#localita").value = Annuncio["Localita"];
  document.querySelector("#classe-energetica").value = Annuncio["IdClasseEnergetica"];
  document.querySelector("#ipe").value = Annuncio["Ipe"];
  document.querySelector("#camere").value = Annuncio["NumeroCamere"];
  document.querySelector("#bagni").value = Annuncio["NumeroBagni"];
  document.querySelector("#box-auto").checked = Annuncio["BoxAuto"];
  document.querySelector("#balcone").checked = Annuncio["Balcone"];
  document.querySelector("#mansarda").checked = Annuncio["Mansarda"];
  document.querySelector("#cantina").checked = Annuncio["Cantina"];
  document.querySelector("#arredato").checked = Annuncio["Arredato"];
  document.querySelector("#giardino").checked = Annuncio["Giardino"];
  document.querySelector("#ascensore").checked = Annuncio["Ascensore"];
}

function ControllaCampiObbligatori(){
  let errore = false;
  if(document.querySelector("#riferimento").value == "" || document.querySelector("#riferimento").value.length > 20){
    document.querySelector("#riferimento").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#riferimento").style.borderColor = "black";

  if(document.querySelector("#titolo").value == ""){
    document.querySelector("#titolo").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#titolo").style.borderColor = "black";

  if(document.querySelector("#contratto").value == "" || document.querySelector("#contratto").value == null){
    document.querySelector("#contratto").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#contratto").style.borderColor = "black";

  if(document.querySelector("#categoria").value == "" || document.querySelector("#categoria").value == null){
    document.querySelector("#categoria").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#categoria").style.borderColor = "black";

  let prezzo = document.querySelector("#prezzo").value;
  if(prezzo.toLowerCase() != "info in agenzia" && prezzo != "0"){
    var pattern = /([0-9]*[.])?[0-9]+/;
    let result = document.querySelector("#prezzo").value.match(pattern);
    let prezzo_giusto = "";
    if(result){
      prezzo_giusto = result[0];
      document.querySelector("#prezzo").value = prezzo_giusto;
    }
    if(prezzo_giusto == "" || prezzo_giusto == "0"){
      document.querySelector("#prezzo").style.borderColor = "red";
      errore = true;
    } else document.querySelector("#prezzo").style.borderColor = "black";
  } else {
    document.querySelector("#prezzo").value = 0;
    document.querySelector("#prezzo").style.borderColor = "black";
  }

  if(document.querySelector("#descrizione").value == ""){
    document.querySelector("#descrizione").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#descrizione").style.borderColor = "black";

  if(document.querySelector("#comune").value == "" || document.querySelector("#comune").value == null){
    document.querySelector("#comune").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#comune").style.borderColor = "black";

  if(document.querySelector("#classe-energetica").value == "" || document.querySelector("#classe-energetica").value == null){
    document.querySelector("#classe-energetica").style.borderColor = "red";
    errore = true;
  } else document.querySelector("#classe-energetica").style.borderColor = "black";

  var pattern = /([0-9]*[.])?[0-9]+/;
  result = document.querySelector("#superficie").value.match(pattern);
  if(result){
    let superficie_giusta = result[0];
    document.querySelector("#superficie").value = superficie_giusta;
  }
  if(errore == true) return false;
  // Inserimento nell'oggetto Camp iDato, tutti i campi
  let Campi = {
    Riferimento: document.querySelector("#riferimento").value,
    Titolo: document.querySelector("#titolo").value,
    IdContratto: document.querySelector("#contratto").value,
    IdCategoria: document.querySelector("#categoria").value,
    Prezzo: document.querySelector("#prezzo").value,
    NumeroLocali: document.querySelector("#numero-locali").value,
    Superficie: document.querySelector("#superficie").value,
    Descrizione: document.querySelector("#descrizione").value,
    IdComune: document.querySelector("#comune").value,
    Indirizzo: document.querySelector("#indirizzo").value,
    Localita: document.querySelector("#localita").value,
    IdClasseEnergetica: document.querySelector("#classe-energetica").value,
    Ipe: document.querySelector("#ipe").value,
    NumeroCamere: document.querySelector("#camere").value,
    Bagni: document.querySelector("#bagni").value,
    BoxAuto: document.querySelector("#box-auto").checked,
    Balcone: document.querySelector("#balcone").checked,
    Mansarda: document.querySelector("#mansarda").checked,
    Cantina: document.querySelector("#cantina").checked,
    Arredato: document.querySelector("#arredato").checked,
    Giardino: document.querySelector("#giardino").checked,
    Ascensore: document.querySelector("#ascensore").checked
  }
  return Campi;
}

function TogliStileErroriCampi(){
  document.querySelector("#errori").style.visibility = "hidden";
  document.querySelector("#riferimento").style.borderColor = "black";
  document.querySelector("#titolo").style.borderColor = "black";
  document.querySelector("#contratto").style.borderColor = "black";
  document.querySelector("#categoria").style.borderColor = "black";
  document.querySelector("#prezzo").style.borderColor = "black";
  document.querySelector("#descrizione").style.borderColor = "black";
  document.querySelector("#comune").style.borderColor = "black";
}
