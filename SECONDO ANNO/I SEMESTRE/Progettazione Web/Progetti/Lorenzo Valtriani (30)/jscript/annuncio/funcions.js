var Foto = [];
var NumeroFoto;
var MaxSottoFoto = 4;
var Indice;         // Indice relativo alla posizione della prima foto da visualizzare a schermo
                    // l'indice fa riferimento al vettore Foto;
var IndiceBackup;

function Carica(){
    let photos = Array.from(document.querySelectorAll(".foto img"));
    NumeroFoto = photos.length;
    Indice = 0;
    IndiceBackup = 0;
    for(let i=0; i<photos.length; i++){
        Foto[i] = photos[i].attributes.src.nodeValue;
    }
    if(NumeroFoto == 0) Foto[0] = document.querySelector("#foto-principale img").getAttribute("src");
}

function FotoSecondarieCaricate(target){
    target.style.visibility = "visible";
}

function SetPrincipale(elem){
    let photos = document.querySelectorAll(".foto img");
    for(let i=0; i<photos.length; i++){
        photos[i].style.border = "";
    }

    elem.style.border = "1px solid black";
    console.log(elem.src);
    let principale = document.querySelector("#foto-principale img");
    principale.src = elem.src;
}

function AggiornaFoto(index){
    if(index <= 0) document.querySelector("#prev").style.visibility = "hidden";
    else document.querySelector("#prev").style.visibility = "visible";

    if(index + MaxSottoFoto >= NumeroFoto) document.querySelector("#next").style.visibility = "hidden";
    else document.querySelector("#next").style.visibility = "visible";

    let spans = document.querySelectorAll(".foto");
    for(let i=0; i<Foto.length; i++){
        if(i < index || i > index + (MaxSottoFoto - 1)) spans[i].style.display = "none";
        else spans[i].style.display = "block";
    }
}

function Prev(){
    Indice = IndiceBackup;
    if(Indice > 0) {
        Indice --;
        IndiceBackup = Indice;
    } else return;

    AggiornaFoto(Indice);
}

function Next(){
    Indice = IndiceBackup;
    if(Indice < NumeroFoto-1) {
        Indice ++;
        IndiceBackup = Indice;
    }
    else return;

    AggiornaFoto(Indice);
}

// Foto ingrandita
function FotoIngrandita(){
    IndiceBackup = Indice;
    let FotoPrincipale = document.querySelector("#foto-principale img").getAttribute("src");
    // Togliere il path assoluto
    if(Foto.indexOf("./foto/"+FotoPrincipale.substr(FotoPrincipale.indexOf('foto/') + 5)) == -1){
        Indice = Foto.indexOf(FotoPrincipale);
    } else Indice = Foto.indexOf("./foto/"+FotoPrincipale.substr(FotoPrincipale.indexOf('foto/') + 5));

    AggiornaPopUp();
    document.querySelector("#pop-up-foto").style.display = "flex";
}

function AggiornaPopUp(){
    let FotoPrincipale = Foto[Indice];
    if(Indice == 0) document.querySelector("#freccia-sinistra").style.visibility = "hidden";
    else document.querySelector("#freccia-sinistra").style.visibility = "visible";

    if(Indice == NumeroFoto - 1) document.querySelector("#freccia-destra").style.visibility = "hidden";
    else document.querySelector("#freccia-destra").style.visibility = "visible";

    if(NumeroFoto == 0) {
      document.querySelector("#freccia-sinistra").style.visibility = "hidden";
      document.querySelector("#freccia-destra").style.visibility = "hidden";
    }
    document.querySelector("#foto-sfondo").setAttribute("src", FotoPrincipale);
}

function ChiudiPopUp(){
    document.querySelector("#pop-up-foto").style.display = "none";
}

function AftImgPopUp(){
    if(Indice == NumeroFoto -1) return;
    Indice ++;
    AggiornaPopUp();
}

function PreImgPopUp(){
    if(Indice == 0) return;
    Indice --;
    AggiornaPopUp();
}
