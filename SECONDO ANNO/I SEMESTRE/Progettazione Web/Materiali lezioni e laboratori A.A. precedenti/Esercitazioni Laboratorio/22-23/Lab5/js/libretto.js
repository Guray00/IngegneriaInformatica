// libretto.js

// Array di messaggi utente, istanziati prima che la pagina venga visualizzata
MESSAGGI_UTENTE = [
  "Inserisci una sequenza di voti tra 18 e 33",
  " non e` un numero",
  " e` un numero minore di 18 o maggiore di 33"
];

// gestore dei messaggi di errore
function stampaErrore(dato, codMess) {
    window.alert("Errore: '" + dato + "' " + MESSAGGI_UTENTE[codMess]);
}

// Oggetto Statistico, costruttore con proprietà e metodi
function Statistico(dati) {
    this.voti 	= this.analizzaDati(dati);
    this.min	= 0;
    this.mas 	= 0;
    this.med	= null;
    this.variab	= null;
}	

Statistico.prototype.analizzaDati = function(datiInput) {
	// Array contenente i voti degli esami inseriti dall'utente (gli elementi sono delle strighe)
	const dati = datiInput.split(";"); 
	// Array da restituire contenenti i voti degli esami (gli elementi sono degli interi)
	const voti = new Array(); 
	
	// Per ogni voto inserito dall'utente
	for (let i = 0; i < dati.length; i++) {
		const voto = Number(dati[i]);	
		if (isNaN(voto)) { 
			// se non è un numero valido
			stampaErrore(dati[i],1);
			return null;
		}		     
		else if (voto<18 || voto>33){ 
			//se non è compreso tra 18 e 33
			stampaErrore(voto,2);	
			return null;
		}
		
		voti[i] = voto;
	}
	
	return voti;
}

Statistico.prototype.datiOk = function() {
	return this.voti != null;
}

Statistico.prototype.calcolaMinimo = function() {
	let minimo = this.voti[0];
	for (let i = this.voti.length-1; i > 0 ; i--)
		minimo = Math.min(minimo, this.voti[i]);

	this.min = minimo;
}	

Statistico.prototype.calcolaMassimo = function() {
	let massimo = this.voti[0];
	for (let i = this.voti.length-1; i > 0 ; i--)
		massimo = Math.max(massimo, this.voti[i]);
	
	this.mas = massimo;
}	

Statistico.prototype.calcolaMedia = function() {   
	/*********************************
		CALCOLO MEDIA QUANTITATIVA
	*********************************/
	let i = 0, 
	    media = 0;
	while (i < this.voti.length) {
		media += this.voti[i];
		i++;
	}
	media /= this.voti.length;
	media = Math.round(media*100)/100;
	
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
	
	this.med = { numerica:media, qualitativa: mediaQual };
}	

Statistico.prototype.calcolaVariabilita = function() {
	/**************************************
		CALCOLO VARIABILTA' QUANTITATIVA
	**************************************/
	let i = 0, 
	    varia = 0;
	do {
		varia += Math.abs(this.voti[i] - this.med.numerica);
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
	document.writeln("Variabilit&agrave;: " + this.variab.numerica + " (" +
					  this.variab.qualitativa +")");
	document.writeln("</div>");
}

Statistico.prototype.stampaTabellaVoti =  function() {
	document.writeln("<div id=\"tabellaVoti\">");
	document.writeln("<table>")
	document.writeln("<caption>Elenco Esami</caption>");
	document.writeln("<tr><th>Voti");
	
	for (let i = 0; i < this.voti.length; i++)
		document.writeln("<tr><td>" + this.voti[i]);
	
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
    stat.calcolaVariabilita();
    stat.stampa();
}
