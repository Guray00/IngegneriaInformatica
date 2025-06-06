"use strict";

import {showMessage, errorHandler, createHTML_img, createHTMLElement, GAME_MESSAGE} from "./../utils/methods.js"
import { centerSvgElement, insertClippedImage } from "./../utils/svgMethods.js";
import { Timer } from "./../utils/definitions.js";


let gameTimer = null;

let turno = null;


document.addEventListener("DOMContentLoaded", () => {
	
	fetch('./../../images/arena.svg')
        .then(response => response.text())
        .then(svg => {
			document.getElementById('imageContainer').innerHTML = svg;
			getGameInfo();
			document.getElementById("giveUpBtn").addEventListener("click", endGame);
		})
		.catch(error => {
			errorHandler(error);
			window.location.href = "./errorPage.php?error_code=" + error.code;
		});


	if(message)
		showMessage(message);

	if(errorMessage)
		errorHandler(errorMessage);
	
	if(gameMessage)
		showMessage(gameMessage, GAME_MESSAGE);
});


/**
 * Recupera le informazioni di gioco dal server e aggiorna l'interfaccia di conseguenza.
 */
function getGameInfo(){
	fetch('./../API/getGameInfo.php')
		.then(response => response.json())
		.then(data => {
			if(data.error !== undefined && data.error)
				throw data;

			turno = data.turno;
			setArenaPG(data.pg1, data.pg2);


			if(data.vittoria !== null){
				setWinningSection(data.vittoria);
				turno = null;
				return;
			}

			setTimer(data.tempoRimanente);

			setTurn(data.tempoRimanente_secondi);

		})
		.catch(error => {
			errorHandler(error);
			window.location.href = "./errorPage.php?error_code=" + error.code;
		});
}

/**
 * Imposta i personaggi nell'arena SVG, aggiorna immagini, nomi, PF e oggetti.
 * @param {Object} PG1 - Dati del primo personaggio (utente)
 * @param {Object} PG2 - Dati del secondo personaggio (nemico)
 */
function setArenaPG(PG1, PG2){
	
	const svgDoc = document.querySelector('svg');
	svgDoc.getElementById('tuoPG').setAttribute("href", "./../../" + PG1.pathImmaginePG);
	svgDoc.getElementById('enemyPG').setAttribute("href", "./../../" + PG2.pathImmaginePG);
	
	if(turno !== null){
		const id = turno? "tuoPG" : "enemyPG";
		svgDoc.getElementById(id).setAttribute("class", "always-animated");
	}



	if(PG1.arma)
		insertClippedImage(svgDoc, "arma_pg1", PG1.arma, "clipArmaPG1");
	if(PG1.armatura)
		insertClippedImage(svgDoc, "armatura_pg1", PG1.armatura, "clipArmaturaPG1");

	if(PG2.arma)
		insertClippedImage(svgDoc, "arma_pg2", PG2.arma, "clipArmaPG2");
	if(PG2.armatura)
		insertClippedImage(svgDoc, "armatura_pg2", PG2.armatura, "clipArmaturaPG2");


	svgDoc.getElementById("nome_pg1").innerHTML = PG1.nome;
	svgDoc.getElementById("nome_pg2").innerHTML = PG2.nome;
	centerSvgElement(svgDoc, "nome_pg1", "PF-box_pg1", false);
	centerSvgElement(svgDoc, "nome_pg2", "PF-box_pg2", false);

	const totalWidth1 = svgDoc.getElementById("PF-box_pg1").getAttribute("width") - svgDoc.getElementById("PF-box_pg1").getAttribute("stroke-width");
	const widthPF1 = Math.max(0, (PG1.temp_PF/PG1.PF) * totalWidth1);
	const widthPF2 = Math.max(0, (PG2.temp_PF/PG2.PF) * totalWidth1);
	
	svgDoc.getElementById("tmpPF_pg1").setAttribute("width", widthPF1);
	svgDoc.getElementById("tmpPF_pg2").setAttribute("width", widthPF2);

	if(widthPF1 === 0){
		svgDoc.getElementById("PF-box_pg1").setAttribute("fill", "#e67e2280");
		svgDoc.getElementById("PF-box_pg1").setAttribute("stroke", "#a95a14");
	}
	if(widthPF2 === 0){
		svgDoc.getElementById("PF-box_pg2").setAttribute("fill", "#e67e2280");
		svgDoc.getElementById("PF-box_pg2").setAttribute("stroke", "#a95a14");
	}

	svgDoc.getElementById("pf_text_pg1").innerHTML = `${PG1.temp_PF}/${PG1.PF}`;
	svgDoc.getElementById("pf_text_pg2").innerHTML = `${PG2.temp_PF}/${PG2.PF}`;

	setZaino(PG1.zaino);

}

/**
 * Imposta il timer visivo e logico per il turno corrente.
 * @param {string|number} tempoRimanente - Tempo rimanente da visualizzare
 */
function setTimer(tempoRimanente){
	document.getElementById("timer").innerText = tempoRimanente;
	if(gameTimer !== null){
		gameTimer.clearTimer();
		gameTimer = null;
	}

	gameTimer = new Timer(changeTurn, 1000);
}

/**
 * Popola la sezione zaino con gli oggetti posseduti dal personaggio.
 * @param {Array} zaino - Lista degli oggetti nello zaino
 */
function setZaino(zaino){
	if(zaino !== null){
		zaino.forEach((item, index) => {
			let space = document.getElementById(`obj_${index}`);
			space.classList.remove("not-clickable");
			let img = createHTML_img(item.PathImmagine, item.Descrizione, `${item.Nome}\n${item.Descrizione}`, `obj_${index}-img`);

			while(space.childElementCount)
				space.removeChild(space.firstChild);
			space.appendChild(img);
			space.addEventListener("click", (e) => {
				if (turno){
					const selected = document.querySelector(".selected-item");
					if (selected && selected !== space){
						selected.classList.remove("selected-item");
						document.getElementById(`input-${selected.id}`).checked = false;
					}

					const id = String(e.target.id).split("-")[0];
					const btn = document.getElementById("actionBtn");

					if (document.getElementById(id).classList.toggle("selected-item")){
						btn.classList.add("oggetto");
						btn.classList.remove("attacco");
						btn.innerText = "Usa Oggetto";
						document.getElementById(`input-${id}`).checked = true;
						document.getElementById(`input-${id}`).value = item.ID;
					} else {
						btn.classList.add("attacco");
						btn.classList.remove("oggetto");
						btn.innerText = "Attacca";
						document.getElementById(`input-${id}`).checked = false;
					}
				}
			});
		});
	}
}

/**
 * Funzione che imposta l'interfaccia a seconda di chi è il turno
 * @param {Number} tempoMassimo indica il tempo massimo che può aspettare il nemico prima di effettuare la mossa se è il suo turno
 */
function setTurn(tempoMassimo){
	const btn = document.getElementById("actionBtn");
	btn.addEventListener("click", play);

	if(!turno){
		btn.setAttribute("disabled", true);
		btn.innerText = "Attendi il tuo turno";
		
		// Tra 6 secondi gioca l'avversario
		// Tempo necessario per leggere il messaggio
		// Se rimanessero meno di 6 secondi, gioca entro la metà del tempo rimanente
		const randomDelay = Math.min(6000, tempoMassimo*500);
		
		setTimeout(() => {
			changeTurn();
		}, randomDelay);
	}
	else{
		btn.removeAttribute("disabled");
		btn.innerText = "Attacca";
		btn.classList.add("attacco");
	}
}

/**
 * Gestisce l'azione del giocatore (attacco o uso oggetto) e invia la richiesta al server.
 */
function play(){
	if(!turno){
		return;
	}

	const formData = new FormData();
	const selectedObj_id = document.querySelector('input[name="usingObj"]:checked');

	if(selectedObj_id){
		formData.append("azione", "usa_oggetto");
		formData.append("oggetto_index", selectedObj_id.value);
	} 
	else {
		formData.append("azione", "attacco");
	}

	sendPlay(formData);
}

/**
 * Funzione che cambia il turno del personaggio eseguendo una mossa casuale
 */
function changeTurn(){
	if(gameTimer){
		gameTimer.clearTimer();
		gameTimer = null;
	}

	const formData = new FormData();
	formData.append("azione", "casuale");

	sendPlay(formData);

}

/**
 * Funzione che si occupa di inviare al server informazioni sull'azione effettuata. Successivamente ricarica lo stato.
 * @param {FormData} formData contennete le informazioni da comunicare all'API
 */
function sendPlay(formData){
	document.body.classList.add("caricamento");
	fetch("./../API/playAction.php", {
		method: "POST",
		body: formData
	})
	.then(response => response.json())
	.then(result => {
		document.body.classList.remove("caricamento");
		if(result.error !== undefined && result.error){
			throw result;
		}
		
		window.location.reload();
	})
	.catch(error => {
		errorHandler(error);
		if(error.code != 1010)
			window.location.href = "./errorPage.php?error_code=" + error.code;
	});
}


/**
 * Mostra la sezione di vittoria o sconfitta e aggiorna l'interfaccia di fine partita.
 * @param {boolean} hasWon - `true` se il giocatore ha vinto, `false` altrimenti
 */
function setWinningSection(hasWon){
	const div = document.getElementById("top-section");

	while(div.childElementCount)
		div.removeChild(div.firstChild);

	const message = hasWon? "Hai vinto!" : "Hai perso!"
	const p = createHTMLElement("p", "winningP", null, message);

	div.appendChild(p);

	const upperBtn = document.getElementById("giveUpBtn");
	upperBtn.parentElement.removeChild(upperBtn);

	const btn = document.getElementById("actionBtn");

	document.querySelectorAll("input").forEach(input => input.remove());
	const bottomSection = document.querySelector(".bag-section");

	bottomSection.parentNode.removeChild(bottomSection);


	const newBtn = btn.cloneNode(true);
	btn.parentNode.replaceChild(newBtn, btn);

	newBtn.disabled = false;
	
	newBtn.innerText = "Ottieni\nRicompense";
	newBtn.classList.add(hasWon? "hasWon":"hasNotWon");
	newBtn.addEventListener("click", endGame);
}

/**
 * Termina la partita e reindirizza alla gestione del personaggio.
 */
function endGame(){
	const formData = new FormData();
	
    document.body.classList.add("caricamento");
    fetch("./../handlers/endGame.php", {
        method: "POST",
        body: formData,
    })
    .then(response => response.json())
    .then(data => {
		document.body.classList.remove("caricamento");
        if(data.ok){
           window.location.href = "./gestisciPersonaggio.php";
        } 
		else{
            console.error("Errore: ", data);
            showMessage(data, IMPORTANT_MESSAGE);
        }
    })
    .catch(error => {
        errorHandler(error);
		window.location.href = "./errorPage.php?error_code=500";
    });
}