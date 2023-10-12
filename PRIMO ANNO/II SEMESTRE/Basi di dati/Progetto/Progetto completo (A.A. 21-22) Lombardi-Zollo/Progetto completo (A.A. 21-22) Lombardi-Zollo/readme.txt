VOTO: 29.5

PROBLEMI:

	- ATTRIBUTI: CFis in Turno, AreaGeografica in Calamita, CodEdificio in Progetto, Capo in LavoriTurno
		=> avrebbero dovuto essere derivati da delle relazioni che non abbiamo messo: poiché così non è garantita l'integrità referenziale. (anche se l'abbiamo implementata con i trigger, dovrebbe essere garantita a priori dalla generazione del codice).