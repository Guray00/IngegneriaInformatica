-- Mostrare le ultime 24h di registrazioni di ogni sensore di un edificio 
CALL Op1_stampa_registrazione('PVL943J4D0VDC411');

-- Mostrare la topologia di un edificio
CALL Op2_topologia('PVL943J4D0VDC411');

-- Mostrare la descrizione dettagliata di un vano
CALL Op3_descrizione_vano('FIO864T8K5QRG966', '69760', '19047');

-- Calcolare il costo di un progetto edilizio
CALL Op4_costo_progetto('45355');

-- Visualizzare lavori in corso e gli operai che lavorano a tale lavoro
CALL Op5_lavori_in_corso('45355');

-- Inserimento di un nuovo materiale generico nel database, collegato a una muratura e a un lavoro
CALL Op6_inserimento_materiale('93199', 'Betulla', '2022-11-21', null, '1500', 'PellegriniSRL', 12, 'Pregiato', '7', '8' , '9', 'MUR00904', 'DettagliInterni');

-- Aggiornamento di SogliaDiSicurezza e visualizza le registrazione di tale sensore che hanno generato alert
CALL Op7_aggiorna_soglia_stampa('HKO90275URK809', '80');

-- Calcolare le ore settimanali di un lavoratore
CALL Op8_ore_settimanali('TEVGDD15W76D112T');

-- Calcola il livello di gravità a una distanza nota
CALL calcola_gravita_km('Alluvione', '2021-01-01', '103429', '70', @IndiceDiGravita);
SELECT @IndiceDiGravita