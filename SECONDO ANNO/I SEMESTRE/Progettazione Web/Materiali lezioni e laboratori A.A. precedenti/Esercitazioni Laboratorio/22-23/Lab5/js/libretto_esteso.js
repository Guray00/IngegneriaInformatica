// libretto.js

// Array di messaggi utente, istanziati prima che la pagina venga visualizzata
MESSAGGI_UTENTE = [
  "Inserisci una sequenza di voti tra 18 e 33 [Materia,voti,crediti;... ; Materia,voti,crediti]",
  " non e` un numero",
  " e` un numero minore di 18 o maggiore di 33",
  " deve contenere solo caratteri"
];

// gestore dei messaggi di errore
function stampaErrore(dato, codMess) {
    window.alert("Errore: '" + dato + "' " + MESSAGGI_UTENTE[codMess]);
}
function checkNumber(inputNumber, minValue, maxValue){
	if (isNaN(inputNumber)) { 
		// se non è un numero valido
		stampaErrore(inputNumber,1);
		return false;
	}		     
	else if (inputNumber < minValue || inputNumber > maxValue){ 
		//se non è compreso tra 18 e 33
		window.alert("Errore: '" + inputNumber + "' e` un numero minore di " + minValue + " o maggiore di " + maxValue);
		return false;
	}

	return true;
}
function checkString(stringa){
	for (let i = 0; i < stringa.length; i++){
		const character = stringa.charAt(i);

		if (character >= 'A' && character <= 'Z')
			//è un carattere tra A e Z (compresi)
			continue;
		if (character >= 'a' && character <= 'z')
			//è un carattere tra a e z (compresi)
			continue;
		if (character == ' ')
			//è il carattere spazio
			continue	
			
		//il carattere non è un carattere valido
		stampaErrore(stringa, 3);
		return false
	}

	return true;
}


// Oggetto Statistico, costruttore con proprietà e metodi
function Statistico(dati) {
    this.voti 	   = this.analizzaDati(dati);
    this.min	   = 0;
    this.mas 	   = 0;
    this.med	   = null;
	this.medPesata = null;
    this.variab	   = null;
}	
Statistico.prototype.analizzaDati = function(datiInput) {
	// Array contenente i voti degli esami inseriti dall'utente (gli elementi sono delle strighe)
	const dati = datiInput.split(";"); 
	// Array da restituire contenenti i voti degli esami (gli elementi sono degli interi)
	const voti = new Array(); 
	
	// Per ogni voto inserito dall'utente
	for (let i = 0; i < dati.length; i++) {
		const dati_splitted = dati[i].split(",");

		const materia = dati_splitted[0];
		const voto = Number(dati_splitted[1]);	
		const crediti = Number(dati_splitted[2]);

		if (!checkString(materia))
			return null;
		if (!checkNumber(voto, 18, 33) || !checkNumber(crediti, 1, 12)){
			//se abiamo ricevuto un input errato
			return null;
		}
				
		voti[i] = {voto, crediti, materia};
	}
	
	return voti;
}

Statistico.prototype.datiOk = function() {
	return this.voti != null;
}

Statistico.prototype.calcolaMinimo = function() {
	let minimo = this.voti[0].voto;
	for (let i = this.voti.length-1; i > 0 ; i--)
		minimo = Math.min(minimo, this.voti[i].voto);

	this.min = minimo;
}	

Statistico.prototype.calcolaMassimo = function() {
	let massimo = this.voti[0].voto;
	for (let i = this.voti.length-1; i > 0 ; i--)
		massimo = Math.max(massimo, this.voti[i].voto);
	
	this.mas = massimo;
}	

Statistico.prototype.calcolaMedia = function() {   
	/*********************************
		CALCOLO MEDIA QUANTITATIVA
	*********************************/
	let i = 0, 
	    media = 0;
	while (i < this.voti.length) {
		media += this.voti[i].voto;
		i++;
	}
	media /= this.voti.length;
	media = Math.round(media*100)/100;
	
	this.med = { numerica:media, qualitativa: calcolaMediaQualitativa(media)};
}	

Statistico.prototype.calcolaMediaPesata = function(){
	/*********************************
		CALCOLO MEDIA QUANTITATIVA
	*********************************/
	let i = 0, 
	    media = 0,
		crediti = 0;

	while (i < this.voti.length) {
		media += this.voti[i].voto * this.voti[i].crediti;
		crediti += this.voti[i].crediti;
		i++;
	}
	media /= crediti;
	media = Math.round(media*100)/100;

	this.medPesata = { numerica:media, qualitativa: calcolaMediaQualitativa(media)};
}
function calcolaMediaQualitativa(media){
	/*********************************
		CALCOLO MEDIA QUALITATIVA
	*********************************/
	let mediaQual = null;
	switch(Math.floor((media-18)/3)) {
		case 0:   mediaQual = "sufficiente";  break;
		case 1:   mediaQual = "discreta";     break;
		case 2:   mediaQual = "buona";        break;
		case 3:   mediaQual = "distinta";     break;
		case 4:   mediaQual = "ottima";       break;
		default:  mediaQual = "eccellente";
	}

	return mediaQual;
}


Statistico.prototype.calcolaVariabilita = function() {
	/**************************************
		CALCOLO VARIABILTA' QUANTITATIVA
	**************************************/
	let i = 0, 
	    varia = 0;
	do {
		varia += Math.abs(this.voti[i].voto - this.med.numerica);
		i++;
	}while (i < this.voti.length);
		
	varia /= this.voti.length;
	varia = Math.round(varia*100)/100;

	/**************************************
		CALCOLO VARIABILTA' QUALITATIVA
	**************************************/
	let variabQual = null;
	switch(Math.ceil(varia/7.5*3)) { // 7.5 massima variabilita
		default:  variabQual = "nessuna";  break;
		case 1:   variabQual = "bassa";    break;
		case 2:   variabQual = "normale";  break;
		case 3:   variabQual = "alta";
	}
	
	this.variab = { numerica: varia, qualitativa: variabQual };
}	


Statistico.prototype.stampaDatiStatistici = function() {
	document.writeln("<div id=\"datiStatistici\">");
	document.writeln("Minimo: " + this.min + "<br>");
	document.writeln("Massimo: " + this.mas + "<br>");	
	document.writeln("Media: " + this.med.numerica + " (" + 
					  this.med.qualitativa +")<br>");
    document.writeln("Media pesata: " + this.medPesata.numerica + " (" + 
					  this.medPesata.qualitativa +")<br>");
	document.writeln("Variabilit&agrave;: " + this.variab.numerica + " (" +
					  this.variab.qualitativa +")");
	document.writeln("</div>");
}

Statistico.prototype.stampaTabellaVoti =  function() {
	document.writeln("<div id=\"tabellaVoti\">");
	document.writeln("<table>")
	document.writeln("<caption>Elenco Esami</caption>");
	document.writeln("<tr><th>Materia</th><th>Crediti</th><th>Voti</th></tr>");
	
	for (let i = 0; i < this.voti.length; i++){
		document.writeln("<tr><td>" + this.voti[i].materia + "</td>");
		document.writeln("<td>" + this.voti[i].crediti + "</td>");
		document.writeln("<td>" + this.voti[i].voto + "</td></tr>");
	}
	
	document.writeln("</table>");
	document.writeln("</div>")
}

Statistico.prototype.stampa = function() {
	// Stampa intestazione pagina HTML (doctype e head)
	document.writeln("<!DOCTYPE hmtl>");
	document.writeln("<html><head><meta charset=\"utf-8\">");
	document.writeln("<link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"./css/img/favicon.ico\"/>");
	document.writeln("<title>Libretto universitario</title>");
	document.writeln("<link rel=\"stylesheet\" href=\"./css/libretto.css\" type=\"text/css\" media=\"screen\"> <!-- css --></head>");
	
	// Qua inizia il <body>
	document.writeln("<body>");
	document.writeln("<div id=\"wrapper\">");
	document.writeln("<div id=\"topnav\"><img src=\"./css/img/unipi_logo.png\" alt=\"Logo\"></div>");
	document.writeln("<p>Libretto Universitario</p>");
	
	this.stampaTabellaVoti();
	this.stampaDatiStatistici();
	
	document.writeln("</div>");
	document.writeln("</body>");
	document.writeln("</html");
}



// funzione eseguita al caricamento della pagina
function main() {
	const voti = window.prompt(MESSAGGI_UTENTE[0]);
    if (voti == null)
		return;
	
	const stat = new Statistico(voti);
    if (!stat.datiOk())				
        return;
        
	stat.calcolaMinimo();	
    stat.calcolaMassimo();
    stat.calcolaMedia();
	stat.calcolaMediaPesata();
    stat.calcolaVariabilita();
    stat.stampa();
}
