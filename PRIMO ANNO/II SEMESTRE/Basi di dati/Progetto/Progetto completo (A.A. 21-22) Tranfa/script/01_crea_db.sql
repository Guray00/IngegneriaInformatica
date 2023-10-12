SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SmartBuildings_CT
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS SmartBuildings_CT;
CREATE SCHEMA IF NOT EXISTS SmartBuildings_CT DEFAULT CHARACTER SET utf8;
USE SmartBuildings_CT;

-- -----------------------------------------------------
-- AREA GENERALE
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table SmartBuildings_CT.Apertura
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Apertura (
  id_muro INT NOT NULL,
  n_apertura INT NOT NULL,
  orientazione varchar(2) NULL,
  larghezza FLOAT NOT NULL,
  altezza FLOAT NOT NULL,
  distanza_spigolo FLOAT NOT NULL,
  altezza_terra FLOAT NOT NULL,
  PRIMARY KEY (id_muro, n_apertura),
  CONSTRAINT chk_Apertura_larghezza CHECK (larghezza > 0),
  CONSTRAINT chk_Apertura_altezza CHECK (altezza > 0),
  CONSTRAINT chk_Apertura_distanza_spigolo CHECK (distanza_spigolo >=0 ),
  CONSTRAINT chk_Apertura_altezza_terra CHECK (altezza_terra >=0 ),
  CONSTRAINT chk_Apertura_orientazione CHECK (orientazione is null or orientazione in ('N','S','O','E','NO','NE','SO','SE') ),
  UNIQUE INDEX SECONDARY_KEY (id_muro ASC, distanza_spigolo ASC) VISIBLE,
  CONSTRAINT fk_Apertura_id_muro
    FOREIGN KEY (id_muro)
    REFERENCES SmartBuildings_CT.Muro (id_muro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Area
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Area (
  id_area INT NOT NULL,
  nome_area varchar(50) not null,
  PRIMARY KEY (id_area))
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Edificio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Edificio (
  id_edificio INT NOT NULL AUTO_INCREMENT,
  tipo_edificio VARCHAR(50) NOT NULL,
  id_area INT NOT NULL,
  PRIMARY KEY (id_edificio),
  INDEX fk_Edificio_id_area_idx (id_area ASC) VISIBLE,
  CONSTRAINT fk_Edificio_id_area
    FOREIGN KEY (id_area)
    REFERENCES SmartBuildings_CT.Area (id_area)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Muro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Muro (
  id_muro INT NOT NULL AUTO_INCREMENT,
  xi FLOAT NOT NULL,
  yi FLOAT NOT NULL,
  xf FLOAT NOT NULL,
  yf FLOAT NOT NULL,
  PRIMARY KEY (id_muro))
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Perimetro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Perimetro (
  id_vano INT NOT NULL,
  id_muro int not null,
  PRIMARY KEY (id_vano, id_muro),
  CONSTRAINT fk_Perimetro_id_vano
    FOREIGN KEY (id_vano)
    REFERENCES SmartBuildings_CT.Vano (id_vano)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Perimetro_id_muro
    FOREIGN KEY (id_muro)
    REFERENCES SmartBuildings_CT.Muro (id_muro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Piano
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Piano (
  id_edificio INT NOT NULL,
  piano INT NOT NULL,
  PRIMARY KEY (id_edificio, piano),
  INDEX fk_Piano_piano_idx (piano ASC) VISIBLE,
  CONSTRAINT fk_Piano_id_edificio
    FOREIGN KEY (id_edificio)
    REFERENCES SmartBuildings_CT.Edificio (id_edificio)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Rischio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Rischio (
  id_area INT NOT NULL,
  rischio VARCHAR(10) NOT NULL,
  dataora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  coeff_rischio FLOAT NOT NULL,
  PRIMARY KEY (id_area, rischio, dataora),
  INDEX fk_Rischio_rishio_idx (rischio ASC) VISIBLE,
  INDEX fk_Rischio_dataora_idx (dataora ASC) VISIBLE,
  CONSTRAINT chk_Rischio_coeff CHECK (coeff_rischio > 0),
  CONSTRAINT chk_Rischio_rischio CHECK (rischio in ('SISMICO','IDRAULICO') ),
  CONSTRAINT fk_Rischio_id_area
    FOREIGN KEY (id_area)
    REFERENCES SmartBuildings_CT.Area (id_area)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Vano
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Vano (
  id_vano INT NOT NULL AUTO_INCREMENT,
  id_edificio INT NOT NULL,
  piano INT NOT NULL,
  funzione VARCHAR(50) NOT NULL,
  lunghezza FLOAT NOT NULL,
  larghezza FLOAT NOT NULL,
  altezza FLOAT NULL,
  PRIMARY KEY (id_vano),
  INDEX fk_Vano_piano_idx (id_edificio ASC, piano ASC) VISIBLE,
  CONSTRAINT chk_Vano_lunghezza CHECK (lunghezza > 0 ),
  CONSTRAINT chk_Vano_larghezza CHECK (larghezza > 0 ),
  CONSTRAINT chk_Vano_altezza CHECK (altezza is NULL or altezza > 0 ),
  CONSTRAINT fk_Vano_piano
    FOREIGN KEY (piano, id_edificio)
    REFERENCES SmartBuildings_CT.Piano (piano, id_edificio)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;

-- -----------------------------------------------------
-- AREA COSTRUZIONE
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Table SmartBuildings_CT.AltroMateriale
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.AltroMateriale (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  tipo_materiale VARCHAR(50) NOT NULL,
  disegno VARCHAR(50) NOT NULL,
  larghezza FLOAT NOT NULL,
  lunghezza FLOAT NOT NULL,
  spessore FLOAT NOT NULL,
  peso_medio FLOAT NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  CONSTRAINT chk_AltroMateriale_lunghezza CHECK (lunghezza > 0 ),
  CONSTRAINT chk_AltroMateriale_larghezza CHECK (larghezza > 0 ),
  CONSTRAINT chk_AltroMateriale_spessore CHECK (spessore > 0 ),
  CONSTRAINT chk_AltroMateriale_peso_medio CHECK (peso_medio > 0 ),
  CONSTRAINT fk_AltroMateriale_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.ImpiegoOperaio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.ImpiegoOperaio (
  id_risorsa char(16) not null, 
  dataora DATETIME NOT NULL,
  ore_lavoro float NOT NULL,
  id_lavoro INT NOT NULL,
  PRIMARY KEY (id_risorsa, dataora),
  CONSTRAINT chk_ImpiegoOperaio_ore_lavoro CHECK (ore_lavoro > 0 ),
  INDEX fk_ImpiegoOperaio_id_lavoro_idx (id_lavoro ASC) VISIBLE,
  CONSTRAINT fk_ImpiegoOperaio_id_risorsa
    FOREIGN KEY (id_risorsa)
    REFERENCES SmartBuildings_CT.Operaio (id_risorsa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ImpiegoOperaio_id_lavoro
    FOREIGN KEY (id_lavoro)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.ImpiegoSupervisore
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.ImpiegoSupervisore (
  id_risorsa char(16) not null, 
  dataora DATETIME NOT NULL,
  ore_lavoro float NOT NULL,
  id_lavoro INT NOT NULL,
  PRIMARY KEY (id_risorsa, dataora),
  CONSTRAINT chk_ImpiegoSupervisore_ore_lavoro CHECK (ore_lavoro > 0 ),
  INDEX fk_ImpiegoSupervisore_id_lavoro_idx (id_lavoro ASC) VISIBLE,
--  CONSTRAINT fk_ImpiegoSupervisore_id_risorsa
--    FOREIGN KEY (id_risorsa)
--    REFERENCES SmartBuildings_CT.Supervisore (id_risorsa)
--    ON DELETE NO ACTION
--    ON UPDATE NO ACTION,
--  CONSTRAINT fk_ImpiegoSupervisore_id_lavoro
--    FOREIGN KEY (id_lavoro)
--    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
--    ON DELETE NO ACTION
--    ON UPDATE NO ACTION)
  CONSTRAINT fk_ImpiegoSupervisore_id_lavoro_id_risorsa
    FOREIGN KEY (id_lavoro, id_risorsa)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro, id_supervisore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ImpiegoSupervisore_id_risorsa
    FOREIGN KEY (id_risorsa)
    REFERENCES SmartBuildings_CT.Supervisore (id_risorsa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Intonaco
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Intonaco (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  tipo_materiale VARCHAR(50) NOT NULL,
  tipo_intonaco VARCHAR(50) NOT NULL,
  colore varchar(50) NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  CONSTRAINT fk_Intonaco_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Lavoro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Lavoro (
  id_lavoro INT NOT NULL AUTO_INCREMENT,
  id_sal INT NOT NULL,
  tipo_lavoro VARCHAR(100) NOT NULL,
  id_supervisore CHAR(16) NOT NULL,
  max_operai INT NOT NULL,
  PRIMARY KEY (id_lavoro),
  CONSTRAINT chk_Lavoro_max_operai CHECK (max_operai > 0 ),
  INDEX fk_Lavoro_id_sal_idx (id_sal ASC) VISIBLE,
  INDEX fk_Lavoro_id_supervisore_idx (id_lavoro, id_supervisore ASC) VISIBLE,
  CONSTRAINT fk_Lavoro_id_sal
    FOREIGN KEY (id_sal)
    REFERENCES SmartBuildings_CT.StatoAvanzamento (id_sal)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  , CONSTRAINT fk_Lavoro_id_supervisore
    FOREIGN KEY (id_supervisore)
    REFERENCES SmartBuildings_CT.Supervisore (id_risorsa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
	)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Materiale
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Materiale (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  nome_materiale VARCHAR(50) NOT NULL,
  data_acquisto datetime NOT NULL default current_timestamp,
  unita_misura VARCHAR(2) NOT NULL,
  costo_unitario float NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  -- CONSTRAINT chk_Materiale_data_acquisto CHECK (data_acquisto <= now() ),
  CONSTRAINT chk_Materiale_unita_misura CHECK (unita_misura in ('MQ','Q','KG') ),
  CONSTRAINT chk_Materiale_costo_unitario CHECK (costo_unitario > 0 ) )
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Mattone
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Mattone (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  tipo_materiale VARCHAR(50) NOT NULL,
  larghezza FLOAT NOT NULL,
  lunghezza FLOAT NOT NULL,
  altezza FLOAT NOT NULL,
  alveolatura FLOAT NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  CONSTRAINT chk_Mattone_lunghezza CHECK (lunghezza > 0 ),
  CONSTRAINT chk_Mattone_larghezza CHECK (larghezza > 0 ),
  CONSTRAINT chk_Mattone_altezza CHECK (altezza > 0 ),
  CONSTRAINT chk_Mattone_alveolatura CHECK (alveolatura between 0 and 100 ),
  CONSTRAINT fk_Mattone_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.OperaGenerale
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.OperaGenerale (
  id_lavoro INT NOT NULL,
  id_edificio INT NOT NULL,
  PRIMARY KEY (id_lavoro),
  INDEX fk_OperaGenerale_id_edificio_idx (id_edificio ASC) VISIBLE,
  CONSTRAINT fk_OperaGenerale_id_lavoro
    FOREIGN KEY (id_lavoro)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OperaGenerale_id_edificio
    FOREIGN KEY (id_edificio)
    REFERENCES SmartBuildings_CT.Edificio (id_edificio)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.OperaImplacato
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.OperaImpalcato (
  id_lavoro INT NOT NULL,
  id_vano INT NOT NULL,
  PRIMARY KEY (id_lavoro),
  INDEX fk_OperaImpalcato_id_vano_idx (id_vano ASC) VISIBLE,
  CONSTRAINT fk_OperaImpalcato_id_lavoro
    FOREIGN KEY (id_lavoro)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OperaImpalcato_id_vano
    FOREIGN KEY (id_vano)
    REFERENCES SmartBuildings_CT.Vano (id_vano)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Operaio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Operaio (
  id_risorsa CHAR(16) NOT NULL,
  costo_orario float NOT NULL,
  PRIMARY KEY (id_risorsa),
  CONSTRAINT chk_Operaio_costo_orario CHECK (costo_orario > 0 ))
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.OperaMuraria
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.OperaMuraria (
  id_lavoro INT NOT NULL,
  id_muro INT NOT NULL,
  lato_applicazione char(2) null,
  spessore float null,
  n_strato tinyint null,
  PRIMARY KEY (id_lavoro),
  CONSTRAINT chk_OperaMuraria_lato_applicazione CHECK (null or lato_applicazione in ('DX','SX') ),
  CONSTRAINT chk_OperaMuraria_spessore CHECK (spessore is null or spessore > 0 ),
  CONSTRAINT chk_OperaMuraria_n_strato CHECK (n_strato is null or n_strato in (1,2,3) ),
  INDEX fk_OperaMuraria_id_muro_idx (id_muro ASC) VISIBLE,
  CONSTRAINT fk_OperaMuraria_id_lavoro
    FOREIGN KEY (id_lavoro)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_OperaMuraria_id_muro
    FOREIGN KEY (id_muro)
    REFERENCES SmartBuildings_CT.Muro (id_muro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Pietra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Pietra (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  tipo_pietra VARCHAR(50) NOT NULL,
  disposizione varchar(50) not null,
  superficie_media FLOAT NOT NULL,
  peso_medio FLOAT NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  CONSTRAINT chk_Pietra_superficie_media CHECK (superficie_media > 0 ),
  CONSTRAINT chk_Pietra_peso_medio CHECK (peso_medio > 0 ),
  CONSTRAINT fk_Pietra_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Progetto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Progetto (
  id_progetto INT NOT NULL AUTO_INCREMENT,
  tipo_progetto varchar(50) not null,
  id_edificio INT NOT NULL,
  data_presentazione DATE not null,
  data_approvazione DATE not null,
  data_inizio DATE not null,
  data_fine_stimata DATE not null,
  PRIMARY KEY (id_progetto),
  -- CONSTRAINT chk_Progetto_data_presentazione CHECK (data_presentazione < CURRENT_DATE ),
  CONSTRAINT chk_Progetto_data_approvazione CHECK (data_approvazione > data_presentazione ),
  CONSTRAINT chk_Progetto_data_inizio CHECK (data_inizio > data_approvazione ),
  CONSTRAINT chk_Progetto_data_fine_stimata CHECK (data_fine_stimata > data_inizio ),
  UNIQUE INDEX SECONDARY_KEY (id_edificio ASC, data_presentazione asc, tipo_progetto ASC) VISIBLE,
  CONSTRAINT fk_Progetto_id_edificio
    FOREIGN KEY (id_edificio)
    REFERENCES SmartBuildings_CT.Edificio (id_edificio)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Piastrella
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Rivestimento (
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  tipo_materiale VARCHAR(50) NOT NULL,
  disegno varchar(50) not null,
  spessore_fuga FLOAT NOT NULL,
  spessore FLOAT NOT NULL,
  larghezza FLOAT NOT NULL,
  lunghezza FLOAT NOT NULL,
  PRIMARY KEY (codice_lotto, fornitore),
  CONSTRAINT chk_Rivestimento_spessore_fuga CHECK (spessore_fuga > 0 ),
  CONSTRAINT chk_Rivestimento_spessore CHECK (spessore > 0 ),
  CONSTRAINT chk_Rivestimento_larghezza CHECK (larghezza > 0 ),
  CONSTRAINT chk_Rivestimento_lunghezza CHECK (lunghezza > 0 ),
  CONSTRAINT fk_Rivestimento_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.StatoAvanzamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.StatoAvanzamento (
  id_sal INT NOT NULL AUTO_INCREMENT,
  data_inizio DATE NOT NULL,
  data_fine_stimata DATE NOT NULL,
  data_fine_effettiva DATE NULL,
  costo_sal float not NULL default 0,
  id_progetto INT NOT NULL,
  PRIMARY KEY (id_sal),
  CONSTRAINT chk_StatoAvanzamento_data_fine_stimata CHECK (data_fine_stimata > data_inizio ),
  CONSTRAINT chk_StatoAvanzamento_data_fine_effettiva CHECK (data_fine_effettiva is NULL or data_fine_effettiva > data_inizio ),
  INDEX fk_StatoAvanzamento_id_progetto_idx (id_progetto ASC) VISIBLE,
  UNIQUE INDEX SECONDARY_KEY (data_inizio ASC, data_fine_stimata ASC, id_progetto ASC) VISIBLE,
  CONSTRAINT fk_StatoAvanzamento_id_progetto
    FOREIGN KEY (id_progetto)
    REFERENCES SmartBuildings_CT.Progetto (id_progetto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Supervisore
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Supervisore (
  id_risorsa CHAR(16) NOT NULL,
  max_operai INT NOT NULL,
  costo_orario float NOT NULL,
  PRIMARY KEY (id_risorsa),
  CONSTRAINT chk_Supervisore_costo_orario CHECK (costo_orario > 0 ),
  CONSTRAINT chk_Supervisore_max_operai CHECK (max_operai > 0 ))
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.UtilizzoMateriale
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.UtilizzoMateriale (
  id_lavoro INT NOT NULL,
  codice_lotto bigint not null,
  fornitore varchar(50) not null,
  quantita FLOAT NOT NULL,
  PRIMARY KEY (id_lavoro, codice_lotto, fornitore),
  CONSTRAINT chk_UtilizzoMateriale_quantita CHECK (quantita > 0 ),
  INDEX fk_UtilizzoMateriale_codice_lotto_fornitore_idx (codice_lotto, fornitore ASC) VISIBLE,
  CONSTRAINT fk_UtilizzoMateriale_codice_lotto_fornitore
    FOREIGN KEY (codice_lotto, fornitore)
    REFERENCES SmartBuildings_CT.Materiale (codice_lotto, fornitore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_UtilizzoMateriale_id_lavoro
    FOREIGN KEY (id_lavoro)
    REFERENCES SmartBuildings_CT.Lavoro (id_lavoro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- AREA MONITORAGGIO
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Alert
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Alert (
  id_sensore INT NOT NULL,
  dataora DATETIME(5) NOT NULL,
  valore_x float not null,
  valore_y float null,
  valore_z float null,
  PRIMARY KEY (id_sensore, dataora))
-- per poter pulire la tabella delle misure
--   CONSTRAINT fk_Alert_id_sensore_data_ora
--    FOREIGN KEY (id_sensore , dataora)
--    REFERENCES SmartBuildings_CT.Misura (id_sensore , dataora)
--    ON DELETE NO ACTION
--    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Misura
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Misura (
  id_sensore INT NOT NULL,
  dataora DATETIME(5) NOT NULL,
  valore_x float not null,
  valore_y float null,
  valore_z float null,
  PRIMARY KEY (dataora, id_sensore),
  INDEX fk_Misura_id_sensore_idx (id_sensore) VISIBLE,
  CONSTRAINT fk_Misura_id_sensore
    FOREIGN KEY (id_sensore)
    REFERENCES SmartBuildings_CT.Sensore (id_sensore)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;


-- -----------------------------------------------------
-- Table SmartBuildings_CT.Sensore
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SmartBuildings_CT.Sensore (
  id_sensore INT NOT NULL AUTO_INCREMENT,
  id_vano INT NOT NULL,
  tipo_sensore VARCHAR(50) NOT NULL,
  valore_soglia FLOAT NULL,
  x float NOT NULL,
  y float NOT NULL,
  z float NOT NULL,
  PRIMARY KEY (id_sensore),
  CONSTRAINT chk_Sensore_valore_soglia CHECK (valore_soglia is null or valore_soglia > 0 ),
  CONSTRAINT chk_Sensore_tipo_sensore CHECK (tipo_sensore in ('ACCELEROMETRO','TEMPERATURA','ESTENSIMETRO') ),
  UNIQUE INDEX SECONDARY_KEY (id_vano ASC, tipo_sensore ASC, x ASC, y ASC, z ASC) VISIBLE,
  CONSTRAINT fk_Sensore_id_vano
    FOREIGN KEY (id_vano)
    REFERENCES SmartBuildings_CT.Vano (id_vano)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
default charset=latin1;

SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
