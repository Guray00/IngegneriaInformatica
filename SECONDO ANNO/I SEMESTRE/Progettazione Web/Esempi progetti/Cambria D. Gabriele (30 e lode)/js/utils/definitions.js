
/**
 * Classe Timer per gestire un timer di conto alla rovescia visualizzato in un elemento DOM con id "timer".  
 * Chiama una funzione di callback specificata quando il timer raggiunge lo zero.
 */
export class Timer{
	/**
	 * Crea un'istanza di Timer e avvia il conto alla rovescia.
	 * @param {Function} funzioneDaChiamare - La funzione di callback da chiamare quando il timer raggiunge lo zero.
	 * @param {number} timer - L'intervallo di tempo in millisecondi per gli aggiornamenti del conto alla rovescia.
	 */
	constructor(funzioneDaChiamare, timer){
		this.timerIntervall = setInterval(() => {
			this.updateTimer(funzioneDaChiamare);
		}, timer);
	}
	
	/**
	 * Aggiorna la visualizzazione del timer e gestisce la logica del conto alla rovescia.
	 * Chiama la funzione di callback quando il timer raggiunge lo zero.
	 * @param {Function} funzioneDaChiamare - La funzione di callback da chiamare quando il timer raggiunge lo zero.
	 */
	updateTimer(funzioneDaChiamare){
		const span = document.getElementById("timer");
		if (span === null){
			if (this.timerIntervall !== null){
				clearInterval(this.timerIntervall);
				this.timerIntervall = null;
			}
			return;
		}
		let [minutes, seconds] = span.innerText.split(":").map(Number);
		if(minutes < 0 || seconds < 0){
			this.clearTimer();
			minutes = 0;
			seconds = 0;
		}
		else if(minutes === 0 && seconds === 0){
			clearInterval(this.timerIntervall);
			funzioneDaChiamare();
			return;
		} 
		else {
			if (seconds === 0){
				--minutes;
				seconds = 59;
			} else {
				--seconds;
			}
		}
		span.innerText = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
	}

	/**
	 * Cancella l'intervallo del timer e reimposta lo stato del timer.
	 * @returns {Timer} L'istanza corrente di Timer.
	 */
	clearTimer(){
		if(this.gameTimer !== null){
			clearInterval(this.timerIntervall);	
			this.gameTimer = null;	
		}

		return this;

	}
}