-- ----------------------------------- INIZIO INSERIMENTO TRIGGER  ----------------------------------------------
DROP TRIGGER IF EXISTS Check_RegitroIlluminazione;
DELIMITER $$
CREATE TRIGGER Check_RegitroIlluminazione
BEFORE INSERT ON RegistroIlluminazione
FOR EACH ROW
BEGIN
  DECLARE IntensitaMinima_ DOUBLE DEFAULT 0;
  DECLARE IntensitaMassima_ DOUBLE DEFAULT 0;
  DECLARE TemperaturaMinima_ DOUBLE DEFAULT 0;
  DECLARE TemperaturaMassima_ DOUBLE DEFAULT 0;
  
  # Acquisisco gli intervalli di funzionamento della luce in questione
  SELECT IntensitaMinima, IntensitaMassima, TemperaturaMinima, TemperaturaMassima 
		 INTO IntensitaMinima_, IntensitaMassima_, TemperaturaMinima_, TemperaturaMassima_
  FROM Luce L
  WHERE L.ID_Luce=NEW.ID_Luce;
  
  # Verifica intervalli di appartenenza
  IF NEW.Intensita<IntensitaMinima_ OR NEW.Intensita>IntensitaMassima_ THEN
    SET @idluce = NEW.ID_Luce;
    SET @intensita = NEW.Intensita;
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_RegitroIlluminazione): Intensità non conforme";
  END IF;
  
  IF NEW.Temperatura<TemperaturaMinima_ OR NEW.Temperatura>TemperaturaMassima_ THEN
    SET @idluce = NEW.ID_Luce;
    SET @temperatura = NEW.Temperatura;
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_RegitroIlluminazione): Temperatura non conforme";
  END IF;
END $$
DELIMITER ;

#INSERT INTO RegistroIlluminazione (ID_Utente, ID_Luce, IstanteInizio, Temperatura, Intensita, IstanteFine)
#VALUES (1, 14, "2021-11-22 06:46:18", 30000, 80, "2021-11-22 07:00:07");

# Controlla che i valori di temperatura e umidità relativi ad una luce rispettino i parametri di questa
DROP TRIGGER IF EXISTS Check_ImpostazioneLuce;
DELIMITER $$
CREATE TRIGGER Check_ImpostazioneLuce
BEFORE INSERT ON ImpostazioneLuce
FOR EACH ROW
BEGIN
  DECLARE IntensitaMinima_ DOUBLE DEFAULT 0;
  DECLARE IntensitaMassima_ DOUBLE DEFAULT 0;
  DECLARE TemperaturaMinima_ DOUBLE DEFAULT 0;
  DECLARE TemperaturaMassima_ DOUBLE DEFAULT 0;
  
  # Acquisisco gli intervalli di funzionamento della luce in questione
  SELECT IntensitaMinima, IntensitaMassima, TemperaturaMinima, TemperaturaMassima 
		 INTO IntensitaMinima_, IntensitaMassima_, TemperaturaMinima_, TemperaturaMassima_
  FROM Luce L
  WHERE L.ID_Luce=NEW.ID_Luce;
  
  # Verifica intervalli di appartenenza
  IF NEW.Intensita<IntensitaMinima_ OR NEW.Intensita>IntensitaMassima_ THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_ImpostazioneLuce): Intensità non conforme";
  END IF;
  
  IF NEW.Temperatura<TemperaturaMinima_ OR NEW.Temperatura>TemperaturaMassima_ THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_ImpostazioneLuce): Temperatura non conforme";
  END IF;
END $$
DELIMITER ;

#INSERT INTO ImpostazioneLuce (Nome, Temperatura, Intensita, ID_Utente, ID_Luce)
#VALUES ("Luce Calda Camera Lorenzo 231", 1000, 120, 2, 14);

# Controlla i valori del contatore bidirezionale che inserisce
# Se c'è vendita, non c'è aquisto, e viceversa.
DROP TRIGGER IF EXISTS Check_ContatoreBidirezionale;
DELIMITER $$
CREATE TRIGGER Check_ContatoreBidirezionale
BEFORE INSERT ON ContatoreBidirezionale
FOR EACH ROW
BEGIN
  IF NEW.AcquistoReteElettrica > 0 AND NEW.VenditaReteElettrica>0 THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_ContatoreBidirezionale): Incoerenza dati! Quando l'energia è venduta non può essere acquistata";
  END IF;
  
  IF (NEW.AcquistoReteElettrica < 0 OR NEW.VenditaReteElettrica < 0 OR NEW.PotenzaTotaleAbitazione < 0) THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "ERROR (Check_ContatoreBidirezionale): Incoerenza dati! Il valore non può essere negativo!";
  END IF;
  
  # Inserimento e correzione automatica della fascia oraria di appartenenza, rispetto all'istante
  IF (HOUR(NEW.Istante) >= 8 AND HOUR(NEW.Istante) < 19) THEN
	SET NEW.ID_FasciaOraria = 1;
  ELSEIF (HOUR(NEW.Istante) >= 19 AND HOUR(NEW.Istante) < 24) THEN
	SET NEW.ID_FasciaOraria = 2;
  ELSEIF (HOUR(NEW.Istante) >= 0 AND HOUR(NEW.Istante) < 8) THEN 
	SET NEW.ID_FasciaOraria = 3;
  END IF;
END $$
DELIMITER ;

#INSERT INTO ContatoreBidirezionale (Istante, AcquistoReteElettrica, VenditaReteElettrica, PotenzaTotaleAbitazione, ID_FasciaOraria)
#VALUES ("2021-11-22 00:01:00", -78, 0, 5, 2);

# Inserisce automaticamente il valore della permanenza, calcolandolo
DROP TRIGGER IF EXISTS CalcolaPermanenza_Accessi;
DELIMITER $$
CREATE TRIGGER CalcolaPermanenza_Accessi
BEFORE INSERT ON RegistroAccessi
FOR EACH ROW
BEGIN
	IF NEW.IstanteFine IS NOT NULL THEN
		# correzione, o inserimento auomatico 
		SET NEW.Permanenza = TIMESTAMPDIFF(second, NEW.IstanteInizio, NEW.IstanteFine);
    END IF;
END $$
DELIMITER ;

#INSERT INTO RegistroAccessi (ID_Utente, IstanteInizio, IstanteFine, Entrata, Uscita) 
#VALUES (3, "2021-11-22 00:52:00", "2021-11-22 00:54:00", 11, 13);