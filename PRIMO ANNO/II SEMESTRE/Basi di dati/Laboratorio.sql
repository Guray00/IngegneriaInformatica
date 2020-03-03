SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE IF NOT EXISTS `Laboratorio`; 
COMMIT;

USE `Laboratorio`;


-- ----------------------------
--  Table structure for `Persona`
-- ----------------------------
DROP TABLE IF EXISTS `Persona`;
CREATE TABLE `Persona` (
  `CodFiscale` char(100) NOT NULL,
  `Cognome` char(100) NOT NULL,
  `Nome` char(100) NOT NULL,
  `Eta` int(11) NOT NULL,
  PRIMARY KEY (`CodFiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `Persona`
-- ----------------------------
BEGIN;
INSERT INTO `Persona` VALUES ('BVEMDL', 'Bove', 'Maddalena', '45'), ('GTTTMO', 'Gatti', 'Tommaso', '37'), ('LPRDOD', 'Lepre', 'Edoardo', '39'), ('LPRNRN', 'Lepre', 'Norina', '83'), ('NTRLRL', 'Nutrie', 'Lorella', '65'), ('RTTBRT', 'Ratto', 'Umberto', '54');
COMMIT;

-- ----------------------------
--  Table structure for `Studente`
-- ----------------------------
DROP TABLE IF EXISTS `Studente`;
CREATE TABLE `Studente` (
  `Matricola` char(6) NOT NULL,
  `Cognome` char(100) NOT NULL,
  `Nome` char(100) NOT NULL,
  `DataNascita` date NOT NULL,
  `DataIscrizione` date NOT NULL,
  `DataLaurea` date DEFAULT NULL,
  `NumeroEsamiSostenuti` int(11) NOT NULL,
  `Facolta` char(100) NOT NULL,
  PRIMARY KEY (`Matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `Studente`
-- ----------------------------
BEGIN;
INSERT INTO `Studente` VALUES ('1194', 'Rossi', 'Marta', '1976-01-05', '1998-08-31', '2005-10-24', '30', 'Ingegneria Meccanica'), ('1282', 'Verdi', 'Matteo', '1981-05-20', '2001-09-10', '2010-04-30', '30', 'Ingegneria Meccanica'), ('2255', 'Grigi', 'Ettore', '1984-02-13', '2003-09-10', '2010-06-20', '30', 'Economia'), ('3893', 'Neri', 'Rita', '1933-10-04', '1950-09-20', '1957-10-03', '28', 'Lettere'), ('4823', 'Rossi', 'Franco', '1990-06-11', '2009-09-15', null, '13', 'Lettere'), ('6288', 'Verdi', 'Lorena', '1987-12-18', '2005-09-15', null, '5', 'Biologia'), ('6556', 'Rosi', 'Rosa', '1977-05-05', '1999-09-25', '2005-02-18', '28', 'Ingegneria Informatica'), ('6566', 'Neri', 'Sergio', '1986-09-04', '2004-09-20', '2009-06-15', '30', 'Economia'), ('7644', 'Viola', 'Antonella', '1981-04-24', '2001-10-01', '2007-02-15', '30', 'Ingegneria Meccanica'), ('7846', 'Turchesi', 'Alberto', '1987-03-20', '2005-08-30', null, '8', 'Economia'), ('8097', 'Gialli', 'Marcella', '1928-07-27', '1947-08-02', '1953-07-15', '30', 'Ingegneria Meccanica'), ('8502', 'Bianchi', 'Dino', '1990-06-18', '2010-09-15', null, '4', 'Agraria');
COMMIT;

