"use strict";

import {showMessage, errorHandler, showInventory, createDeleteBox, createHTML_img, GAME_MESSAGE} from "./../utils/methods.js";

let usedPU = {
	PF: 0,
	FOR: 0,
	DES: 0
};

document.addEventListener("DOMContentLoaded", () =>{
	document.getElementById("backToDash").addEventListener("click", (e)=>{
		e.preventDefault();
		window.location.href = "./dashboard.php";
	});
	document.getElementById("deletePG").addEventListener("click", createDeleteBox);
	
	configurePage();

	if(message){
		showMessage(message);
	}
	if(endgameMessage){
		showMessage(endgameMessage, GAME_MESSAGE);
	}
	if(errorMessage){
		errorHandler(errorMessage);
	}
});

document.addEventListener("click", () => {
	const menu = document.getElementById("remove-item-menu");
	menu.classList.remove("show");
	while(menu.childElementCount)
		menu.removeChild(menu.firstChild);
})


function configurePage(){
	fetch("./../API/getCurrentPGinfos.php")
		.then(response => response.json())
		.then(PG => {
			if(PG.error !== undefined && PG.error){
				throw PG;
			}
			if(PG.puntiUpgrade > 0)
				setUpgradePointsPrivileges(PG);
			
			setEquimpent(PG.arma, PG.armatura, PG.zaino, PG.elementInfo);

		})
		.catch(error => {
			errorHandler(error);
			return;
		})
}

function setUpgradePointsPrivileges(PG){
	let btn = document.getElementById("more-PF");
	btn.classList.add("clickable");
	btn.addEventListener("click", (e) =>{
		aggiornaStat(e.target.id, true, PG);
	});

	document.getElementById("less-PF").addEventListener("click", (e) =>{
		aggiornaStat(e.target.id, false, PG);
	});
	

	if(PG.FOR < PG.MAX_FOR_DES){
		btn = document.getElementById("more-FOR")
		btn.classList.add("clickable");
		btn.addEventListener("click", (e) =>{
			aggiornaStat(e.target.id, true, PG);
		});
	}
	
	document.getElementById("less-FOR").addEventListener("click", (e) =>{
		aggiornaStat(e.target.id, false, PG);
	});
	
	if(PG.DES < PG.MAX_FOR_DES){
		btn = document.getElementById("more-DES");
		btn.classList.add("clickable");
		btn.addEventListener("click", (e) =>{
			aggiornaStat(e.target.id, true, PG);
		});
	}
	
	document.getElementById("less-DES").addEventListener("click", (e) =>{
		aggiornaStat(e.target.id, false, PG);
	});
}

/**
 * Aggiorna le statistiche del personaggio.
 * @param {string} id id della statistica da modificare
 * @param {boolean} aumenta se `true` aumenta il valore, altrimenti lo diminuisce
 * @param {Array} PG contiene informazioni sulle statistiche del personaggio
 */
export function aggiornaStat(id, aumenta, PG){
	let statId = id.split("-")[1];
	let upd = (aumenta)? 1 : -1;
	let totalUsedPU = Object.values(usedPU).reduce((prev, curr) => {
		return prev + curr;
	}, 0);

	if(aumenta && PG.puntiUpgrade === totalUsedPU){
		return;
	}
	
	switch (statId){
        case "PF":
			if(!aumenta && !usedPU.PF)
				return;
            PG.PF = Number(PG.PF) + upd;
            usedPU.PF += upd;
			document.getElementById(`less-${statId}`).classList.toggle("clickable", (usedPU.PF));
            break;
        case "FOR":
			if(!aumenta && !usedPU.FOR)
				return;
            if (PG.FOR < PG.MAX_FOR_DES && PG.FOR > PG.MIN_FOR_DES){
                PG.FOR += upd;
                usedPU.FOR += upd;
				document.getElementById(`more-${statId}`).classList.toggle("clickable", (PG.FOR !== PG.MAX_FOR_DES));
				document.getElementById(`less-${statId}`).classList.toggle("clickable", (PG.FOR !== PG.MIN_FOR_DES && usedPU.FOR));
				let danno = PG.DAMAGE_LOOKUP[PG.FOR];
				if(PG.arma !== null){
					danno += PG.arma['Danno'];
				}
				document.getElementById("damage").innerText = danno;
				document.getElementById("damage").classList.toggle("updated", (PG.damage !== danno));
				break;
            } 
            return;
        case "DES":
			if(!aumenta && !usedPU.DES)
				return;
            if (PG.DES < PG.MAX_FOR_DES && PG.DES > PG.MIN_FOR_DES){
                PG.DES += upd;
                usedPU.DES += upd;
				document.getElementById(`more-${statId}`).classList.toggle("clickable", (PG.DES !== PG.MAX_FOR_DES));
				document.getElementById(`less-${statId}`).classList.toggle("clickable", (PG.DES !== PG.MIN_FOR_DES && usedPU.DES));
				document.getElementById("dodge").innerText = `${PG.DODGE_LOOKUP[PG.DES]}%`;
				document.getElementById("dodge").classList.toggle("updated", (PG.dodgingChance !== PG.DODGE_LOOKUP[PG.DES]));
				break;
            } 
			return;
        default:
            return;
    }

	totalUsedPU += upd;

	document.getElementById(statId).value = PG[statId];
	document.getElementById(statId).classList.toggle("updated", usedPU[statId]);
	
	document.getElementById("more-PF").classList.toggle("clickable", (PG.puntiUpgrade !== totalUsedPU));
	document.getElementById("more-FOR").classList.toggle("clickable", (PG.puntiUpgrade !== totalUsedPU));
	document.getElementById("more-DES").classList.toggle("clickable", (PG.puntiUpgrade !== totalUsedPU));

	document.getElementById("PU-points").innerText = PG.puntiUpgrade - totalUsedPU;

	document.getElementById("upgradeStats").toggleAttribute("disabled", (totalUsedPU === 0));
	
}

function setEquimpent(arma = null, armatura = null, zaino = null, elementi = null){
	let space = null;
	let img = null;
	if(arma !== null){
		space = document.getElementById("arma");
		
		img = createHTML_img(arma.PathImmagine, arma.Descrizione, `${arma.Nome}\n${arma.Descrizione}`, "arma-img");
		
		if(space.classList.contains('disabled-item')){
			space.title = "Non puoi rimuovere l'arma, hai una battaglia in corso!";
		}
		
		if(arma.Elemento === elementi['elementoPG']){
			space.classList.add("allineato");
			img.title += " - Allineato (+1 danni effettuati)";
		}
		else if(arma.Elemento === elementi['prevalsoDa']){
			space.classList.add("opposto");
			img.title += ` - Opposto (prevalenza anche su ${elementi['elementoPG']})`;
		}
		
		while(space.childElementCount)
			space.removeChild(space.firstChild);
		space.appendChild(img);
		space.addEventListener("click",(e) => {
			addRemoveMenu(e, arma.ID);
			e.stopPropagation();
		});
	}
	if(armatura !== null){
		space = document.getElementById("armatura");
	
		img = createHTML_img(armatura.PathImmagine, armatura.Descrizione, `${armatura.Nome}\n${armatura.Descrizione}`, "armatura-img");

		if(armatura.Elemento === elementi['elementoPG']){
			space.classList.add("allineato");
			img.title += " - Allineato (+1 Protezione Danni)";
		}
		else if(armatura.Elemento === elementi['prevalsoDa']){
			space.classList.add("opposto");
			img.title += ` - Opposto (Non sei più prevalso da ${elementi['prevalsoDa']})`;
		}
		
		while(space.childElementCount)
			space.removeChild(space.firstChild);
		space.appendChild(img);
		space.addEventListener("click",(e) => {
			addRemoveMenu(e, armatura.ID);
			e.stopPropagation();
		});
	}
	if(zaino !== null){
		zaino.forEach((item, index) => {
			space = document.getElementById(`obj_${index}`);
			
			img = createHTML_img(item.PathImmagine, item.Descrizione, `${item.Nome}\n${item.Descrizione}`, `obj_${index}-img`);

			while(space.childElementCount)
				space.removeChild(space.firstChild);
			space.appendChild(img);
			space.addEventListener("click",(e) => {
				addRemoveMenu(e, item.ID);
				e.stopPropagation();
			});
		});
	}

	space = document.querySelectorAll(".item-slot.bag-item");
	space.forEach(item => {
		if(!item.childElementCount){
			item.addEventListener("click", (e) => {
				const id = String(e.target.id).split("-")[0];
				showInventory(false, true, id);
			});
		}
	})
}

function addRemoveMenu(e, itemId){
	e.preventDefault();

	const menu = document.getElementById("remove-item-menu");

	menu.style.left = `${e.pageX}px`;
	menu.style.top = `${e.pageY}px`;
	menu.style.display = "block";
	

	const img = createHTML_img("images/trash.svg", "Rimuovi l'Item", "Clicca l'immagine per rimuovere l'oggetto da questo personaggio");
	img.addEventListener("click", () =>{
		const formData = new FormData();
		
		formData.append("itemId_remove", JSON.stringify(itemId));

		fetch("./../API/togglePGItem.php", {
			method: "POST",
			body: formData,
		})
			.then(response => response.json())
			.then(data =>{
				if(data.error !== undefined && data.error){
				throw data;
				}

				window.location.reload();
			})
			.catch(error => {
				errorHandler(error);
			});
	})

	while(menu.childElementCount)
		menu.removeChild(menu.firstChild);
	menu.appendChild(img);

	menu.classList.add("show");
}