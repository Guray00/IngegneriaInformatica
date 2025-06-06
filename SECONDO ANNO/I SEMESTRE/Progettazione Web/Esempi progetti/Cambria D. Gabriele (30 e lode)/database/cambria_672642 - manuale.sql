-- MySQL Version: 5.7.28
DROP DATABASE if exists cambria_672642;
CREATE DATABASE cambria_672642;
USE cambria_672642;

CREATE TABLE Account (
    ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Username VARCHAR(50) COLLATE utf8_bin NOT NULL UNIQUE,
    Password VARCHAR(255) COLLATE utf8_bin NOT NULL,
    Monete INT NOT NULL DEFAULT 10,
    RefreshNegozio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ImmagineProfilo VARCHAR(255) COLLATE utf8_bin NOT NULL DEFAULT "images/pics/default.svg"
);

CREATE TABLE Element(
    Nome VARCHAR(50) NOT NULL PRIMARY KEY,
    PathImmagine VARCHAR(255) COLLATE utf8_bin DEFAULT NULL,
    PathImmaginePG VARCHAR(255) COLLATE utf8_bin DEFAULT NULL,
    ModificatoreFor INT DEFAULT 0,
    ModificatoreDes INT DEFAULT 0,
    RecuperoVita INT DEFAULT 0,
    PrevaleSu VARCHAR(50) DEFAULT NULL,
    PrevalsoDa VARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (PrevaleSu) REFERENCES Element(Nome) ON DELETE SET NULL,
    FOREIGN KEY (PrevalsoDa) REFERENCES Element(Nome) ON DELETE SET NULL
);

CREATE TABLE ItemType(
    Nome VARCHAR(50) NOT NULL PRIMARY KEY
);

CREATE TABLE Item (
    ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Nome VARCHAR(100) COLLATE utf8_bin NOT NULL UNIQUE,
    Descrizione VARCHAR(60) COLLATE utf8_bin NOT NULL,
    Elemento VARCHAR(50),
    PathImmagine VARCHAR(255) COLLATE utf8_bin DEFAULT NULL,
    Tipologia VARCHAR(50) NOT NULL,
    Costo INT NOT NULL,
    Danno INT DEFAULT 0,
    ProtezioneDanno INT DEFAULT 0,
    RecuperoVita INT DEFAULT 0,
    ModificatoreFor INT DEFAULT 0,
    ModificatoreDes INT DEFAULT 0,
	FOREIGN KEY (Elemento) REFERENCES Element(Nome),
	FOREIGN KEY (Tipologia) REFERENCES ItemType(Nome)
);

CREATE TABLE Inventario (
    Proprietario INT NOT NULL,
    Oggetto INT NOT NULL,
    Quantita INT NOT NULL DEFAULT 1,
    PRIMARY KEY(Proprietario, Oggetto),
    FOREIGN KEY (Proprietario) REFERENCES Account(ID) ON DELETE CASCADE,
    FOREIGN KEY (Oggetto) REFERENCES Item(ID) ON DELETE CASCADE
);

CREATE TABLE Personaggi (
    Nome VARCHAR(100) COLLATE utf8_bin NOT NULL,
    Proprietario INT NOT NULL,
    Elemento VARCHAR(50) NOT NULL,
    Forza INT NOT NULL,
    Destrezza INT NOT NULL,
    PuntiVita INT NOT NULL DEFAULT 50,
    Armatura INT DEFAULT NULL,     -- Riferimento all'ID dell'armatura equipaggiata
    Arma INT DEFAULT NULL,		 -- Riferimento all'ID dell'arma equipaggiata
    Livello INT NOT NULL DEFAULT 1,
    PuntiExp INT NOT NULL DEFAULT 0,
    PuntiUpgrade INT NOT NULL DEFAULT 5,
    PRIMARY KEY (Nome, Proprietario),
    FOREIGN KEY (Proprietario) REFERENCES Account(ID) ON DELETE CASCADE,
    FOREIGN KEY (Arma) REFERENCES Item(ID) ON DELETE SET NULL,    		-- Riferimento all'arma equipaggiata
    FOREIGN KEY (Armatura) REFERENCES Item(ID) ON DELETE SET NULL,		-- Riferimento all'armatura equipaggiata
    FOREIGN KEY (Elemento) REFERENCES Element(Nome) ON DELETE NO ACTION
);

CREATE TABLE Zaino (
    Personaggio VARCHAR(100) COLLATE utf8_bin NOT NULL,
    Proprietario INT NOT NULL,
    Oggetto INT NOT NULL,
    Quantita INT NOT NULL DEFAULT 1,
    PRIMARY KEY (Personaggio, Proprietario, Oggetto),
    FOREIGN KEY (Personaggio, Proprietario) REFERENCES Personaggi(Nome, Proprietario) ON DELETE CASCADE,
    FOREIGN KEY (Oggetto) REFERENCES Item(ID) ON DELETE CASCADE
);

CREATE TABLE Combattimenti (
    Giocatore1_Nome VARCHAR(100) COLLATE utf8_bin NOT NULL,
    Giocatore1_Proprietario INT NOT NULL,
    Terminata BOOLEAN NOT NULL DEFAULT 0,
    Vittoria_Giocatore1 BOOLEAN DEFAULT NULL,
    StatoPersonaggi JSON DEFAULT NULL,
    DataInizioBattaglia DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    DataUltimoTurno DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Giocatore1_Nome, Giocatore1_Proprietario, DataInizioBattaglia),
    FOREIGN KEY (Giocatore1_Nome, Giocatore1_Proprietario) REFERENCES Personaggi(Nome, Proprietario) ON DELETE CASCADE
);

CREATE TABLE Negozio (
    Proprietario INT NOT NULL,
    Oggetto INT NOT NULL,
    PRIMARY KEY (Proprietario, Oggetto),
    FOREIGN KEY (Proprietario) REFERENCES Account(ID) ON DELETE CASCADE,
    FOREIGN KEY (Oggetto) REFERENCES Item(ID) ON DELETE CASCADE
);

DELIMITER //

-- Trigger per validare Monete in Account
CREATE TRIGGER trg_account_monete_check
BEFORE INSERT ON Account
FOR EACH ROW
BEGIN
    IF NEW.Monete < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monete deve essere >= 0';
    END IF;
END;
//

CREATE TRIGGER trg_account_monete_update_check
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.Monete < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monete deve essere >= 0';
    END IF;
END;
//

-- Trigger per validare Costo, Danno, Armatura, RecuperoVita in Item
CREATE TRIGGER trg_item_check
BEFORE INSERT ON Item
FOR EACH ROW
BEGIN
    IF NEW.Costo < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Costo deve essere >= 0';
    END IF;
    IF NEW.Danno < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danno deve essere >= 0';
    END IF;
    IF NEW.ProtezioneDanno < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ProtezioneDanno deve essere >= 0';
    END IF;
    IF NEW.RecuperoVita < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RecuperoVita deve essere >= 0';
    END IF;
END;
//

CREATE TRIGGER trg_item_update_check
BEFORE UPDATE ON Item
FOR EACH ROW
BEGIN
    IF NEW.Costo < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Costo deve essere >= 0';
    END IF;
    IF NEW.Danno < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Danno deve essere >= 0';
    END IF;
    IF NEW.ProtezioneDanno < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ProtezioneDanno deve essere >= 0';
    END IF;
    IF NEW.RecuperoVita < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RecuperoVita deve essere >= 0';
    END IF;
END;
//

-- Trigger per validare Quantita in Inventario
CREATE TRIGGER trg_inventario_quantita_check
BEFORE INSERT ON Inventario
FOR EACH ROW
BEGIN
    IF NEW.Quantita <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantita deve essere > 0';
    END IF;
END;
//

CREATE TRIGGER trg_inventario_quantita_update_check
BEFORE UPDATE ON Inventario
FOR EACH ROW
BEGIN
    IF NEW.Quantita <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantita deve essere > 0';
    END IF;
END;
//

-- Trigger per validare Forza, Destrezza, Livello, PuntiExp, PuntiUpgrade in Personaggi
CREATE TRIGGER trg_personaggi_check
BEFORE INSERT ON Personaggi
FOR EACH ROW
BEGIN
    IF NEW.Forza < -10 OR NEW.Forza > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Forza deve essere tra -10 e 10';
    END IF;
    IF NEW.Destrezza < -10 OR NEW.Destrezza > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destrezza deve essere tra -10 e 10';
    END IF;
    IF NEW.Livello < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livello deve essere >= 1';
    END IF;
    IF NEW.PuntiExp < 0 OR NEW.PuntiExp > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiExp deve essere tra 0 e 100';
    END IF;
    IF NEW.PuntiUpgrade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiUpgrade deve essere >= 0';
    END IF;
END;
//

CREATE TRIGGER trg_personaggi_update_check
BEFORE UPDATE ON Personaggi
FOR EACH ROW
BEGIN
    IF NEW.Forza < -10 OR NEW.Forza > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Forza deve essere tra -10 e 10';
    END IF;
    IF NEW.Destrezza < -10 OR NEW.Destrezza > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destrezza deve essere tra -10 e 10';
    END IF;
    IF NEW.Livello < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livello deve essere >= 1';
    END IF;
    IF NEW.PuntiExp < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiExp deve essere >= 100';
    END IF;
    IF NEW.PuntiUpgrade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PuntiUpgrade deve essere >= 0';
    END IF;
END;
//

CREATE TRIGGER trg_welcome_gift
AFTER INSERT ON Account
FOR EACH ROW
BEGIN
    INSERT INTO Inventario  (Proprietario, Oggetto, Quantita)
    SELECT NEW.ID, 16, 1;
END;
//

CREATE TRIGGER trg_zaino_check
BEFORE INSERT ON Zaino
FOR EACH ROW
BEGIN
    DECLARE tipologia_invalid BOOLEAN;

    SELECT COUNT(*) > 0 INTO tipologia_invalid
    FROM Item
    WHERE ID = NEW.Oggetto AND Tipologia IN ('arma', 'armatura', 'box');

    IF tipologia_invalid THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipologia non valida per Zaino (arma, armatura, box non consentiti)';
    END IF;
END;
//

CREATE TRIGGER trg_zaino_update_check
BEFORE UPDATE ON Zaino
FOR EACH ROW
BEGIN
    DECLARE tipologia_invalid BOOLEAN;

    SELECT COUNT(*) > 0 INTO tipologia_invalid
    FROM Item
    WHERE ID = NEW.Oggetto AND Tipologia IN ('arma', 'armatura', 'box');

    IF tipologia_invalid THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipologia non valida per Zaino (arma, armatura, box non consentiti)';
    END IF;
END;
//

CREATE TRIGGER trg_personaggi_exp_update_for_lvl_up
BEFORE UPDATE ON Personaggi
FOR EACH ROW
BEGIN
    DECLARE proprietario_id INT;
    DECLARE livelli_guadagnati INT;

    IF NEW.PuntiExp >= 100 THEN
        SET livelli_guadagnati =  NEW.PuntiExp DIV 100;

        SET NEW.PuntiExp = NEW.PuntiExp % 100;
        SET NEW.Livello = NEW.Livello + livelli_guadagnati;
        SET NEW.PuntiUpgrade = NEW.PuntiUpgrade + (3 * livelli_guadagnati);

        SET proprietario_id = NEW.Proprietario;

        UPDATE Account
        SET Monete = Monete + (40 * livelli_guadagnati)
        WHERE ID = proprietario_id;


        INSERT INTO Inventario (Proprietario, Oggetto, Quantita)
        VALUES (proprietario_id, 15, livelli_guadagnati)
        ON DUPLICATE KEY UPDATE Quantita = Quantita + livelli_guadagnati;
    END IF;
END;
//

CREATE TRIGGER trg_combattimenti_terminata_check
BEFORE UPDATE ON Combattimenti
FOR EACH ROW
BEGIN
    IF NEW.Terminata = 1 AND NEW.Vittoria_Giocatore1 IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Devi specificare il vincitore quando la battaglia è terminata';
    END IF;
END;
//

CREATE TRIGGER trg_combattimenti_check_valid_insert
BEFORE INSERT ON Combattimenti
FOR EACH ROW
BEGIN
    IF NEW.Vittoria_Giocatore1 IS NULL THEN
        IF NEW.StatoPersonaggi IS NULL THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'StatoPersonaggi non può essere NULL se non è settata Vittoria_Giocatore1';
        END IF;
    END IF;

    IF NEW.DataUltimoTurno < NEW.DataInizioBattaglia THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "L'ultimo turno non può essere precedente all'inizio della battaglia";
    END IF;
END; 
//

CREATE TRIGGER trg_combattimenti_check_valid_update
BEFORE UPDATE ON Combattimenti
FOR EACH ROW
BEGIN
    DECLARE msg TEXT;
    
    IF NEW.Vittoria_Giocatore1 IS NULL THEN
        IF NEW.StatoPersonaggi IS NULL THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'StatoPersonaggi non può essere NULL se non è settata Vittoria_Giocatore1';
        END IF;
    END IF;

    IF NEW.DataUltimoTurno < OLD.DataUltimoTurno THEN
        SET msg = CONCAT('Errore: Il nuovo turno deve iniziare dopo quello precedente. NEW.DataUltimoTurno: ', NEW.DataUltimoTurno, ', OLD.DataUltimoTurno: ', OLD.DataUltimoTurno);
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = msg;
    END IF;
END; 
//

CREATE TRIGGER trg_combattimenti_update_victory_status
BEFORE UPDATE ON Combattimenti
FOR EACH ROW
BEGIN
    IF NEW.Vittoria_Giocatore1 IS NOT NULL THEN
        SET NEW.StatoPersonaggi = NULL;
        SET NEW.Terminata = 1;
        SET NEW.DataUltimoTurno = NULL;
    END IF;
END;
//

DELIMITER ;