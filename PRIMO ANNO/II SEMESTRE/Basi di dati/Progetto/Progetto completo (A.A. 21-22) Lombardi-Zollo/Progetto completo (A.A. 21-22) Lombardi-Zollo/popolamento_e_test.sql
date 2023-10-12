/* Popolamento e test operazione 1 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);
INSERT INTO Edificio	VALUES("edif2",TRUE,"Bilocale","Italia",43.5,10.3);

INSERT INTO Calamita 	VALUES("Italia","2023-01-24","Sismico",42,11);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");
INSERT INTO Pianta		VALUES(0,4,"edif2");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano1",4,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano2",3,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano3",4,3,4,0,"edif2",3);
INSERT INTO Vano		VALUES("vano4",4,3,3.5,0,"edif2",3);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif2",26,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif2",26,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif2",16,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif2",16,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif2",7.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif2",7.5,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif2",10,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif2",10,TRUE);

INSERT INTO Sensore		VALUES("sens1","Posizione",2,3.65,8,"Parete S","vano1",1,"edif1");
INSERT INTO Sensore		VALUES("sens2","Posizione",6.03,2.78,8,"Parete N","vano2",0,"edif2");

INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),5.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),8,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),10,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),6.5,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7.1,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),7.9,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.7,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),9.8,"sens2");

CALL trovaAlert("Italia", "2023-01-24", "Sismico");

/* Popolamento e Test Operazione 2 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);
INSERT INTO Edificio	VALUES("edif2",TRUE,"Bilocale","Italia",43.5,10.3);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");
INSERT INTO Pianta		VALUES(0,4,"edif2");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano1",4,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano2",3,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano3",4,3,4,0,"edif2",3);
INSERT INTO Vano		VALUES("vano4",4,3,3.5,0,"edif2",3);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif2",26,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif2",26,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif2",16,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif2",16,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif2",7.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif2",7.5,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif2",10,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif2",10,TRUE);


INSERT INTO Finestra    VALUES("fine1","vano1",0,"edif1",2,2,"Sud");
INSERT INTO Finestra    VALUES("fine2","vano1",0,"edif1",2,2,"Sud");
INSERT INTO Finestra    VALUES("fine3","vano2",0,"edif1",2,2,"Ovest");
INSERT INTO Finestra    VALUES("fine4","vano4",0,"edif1",2,2,"Est");
INSERT INTO Finestra    VALUES("fine5","vano3",0,"edif1",2,2,"Nord");

INSERT INTO Finestra    VALUES("fine6","vano1",1,"edif1",2,2,"Sud");
INSERT INTO Finestra    VALUES("fine7","vano1",1,"edif1",2,2,"Sud");
INSERT INTO Finestra    VALUES("fine8","vano1",1,"edif1",2,2,"Est");
INSERT INTO Finestra    VALUES("fin10","vano2",1,"edif1",2,2,"Ovest");
INSERT INTO Finestra    VALUES("fin11","vano3",1,"edif1",2,2,"Nord");
INSERT INTO Finestra    VALUES("fin12","vano3",1,"edif1",2,2,"Nord");
INSERT INTO Finestra    VALUES("fin13","vano3",1,"edif1",2,2,"Est");

INSERT INTO Finestra    VALUES("fin14","vano1",0,"edif2",1,1.6,"Ovest");
INSERT INTO Finestra    VALUES("fin15","vano2",0,"edif2",1,1.6,"Ovest");
INSERT INTO Finestra    VALUES("fin16","vano3",0,"edif2",1,1.6,"Nord");
INSERT INTO Finestra    VALUES("fin17","vano4",0,"edif2",1,1.6,"Est");


INSERT INTO PuntoAccessoEsterno VALUES("IDex1",2,3,"Sud","Porta","vano1",0,"edif1");
INSERT INTO PuntoAccessoEsterno VALUES("IDex2",2,3,"Nord","Porta","vano3",0,"edif1");
INSERT INTO PuntoAccessoEsterno VALUES("IDex3",1.5,2.5,"Est","Porta","vano2",1,"edif1");
INSERT INTO PuntoAccessoEsterno VALUES("IDex4",1,2.2,"Sud","Portone","vano1",0,"edif2");


INSERT INTO PuntoAccessoInterno VALUES("IDin1","Porta",1,2.2);
INSERT INTO PuntoAccessoInterno VALUES("IDin2","Porta",1,2.2);
INSERT INTO PuntoAccessoInterno VALUES("IDin3","Porta",1,2.2);
INSERT INTO PuntoAccessoInterno VALUES("IDin4","Porta",1,2.2);
INSERT INTO PuntoAccessoInterno VALUES("IDin5","Porta",1,2.2);
INSERT INTO PuntoAccessoInterno VALUES("IDin6","Arco",1.5,2.5);
INSERT INTO PuntoAccessoInterno VALUES("IDin7","Porta",0.8,2);
INSERT INTO PuntoAccessoInterno VALUES("IDin8","Porta",0.8,2);

INSERT INTO AccessoI VALUES("IDin1","vano1",0,"edif1","Nord");
INSERT INTO AccessoI VALUES("IDin1","vano3",0,"edif1","Sud");
INSERT INTO AccessoI VALUES("IDin2","vano2",0,"edif1","Est");
INSERT INTO AccessoI VALUES("IDin2","vano3",0,"edif1","Ovest");
INSERT INTO AccessoI VALUES("IDin3","vano3",0,"edif1","Est");
INSERT INTO AccessoI VALUES("IDin3","vano4",0,"edif1","Ovest");
INSERT INTO AccessoI VALUES("IDin4","vano1",1,"edif1","Nord");
INSERT INTO AccessoI VALUES("IDin4","vano2",1,"edif1","Sud");
INSERT INTO AccessoI VALUES("IDin5","vano2",1,"edif1","Nord");
INSERT INTO AccessoI VALUES("IDin5","vano3",1,"edif1","Sud");
INSERT INTO AccessoI VALUES("IDin6","vano1",0,"edif2","Nord");
INSERT INTO AccessoI VALUES("IDin6","vano2",0,"edif2","Sud");
INSERT INTO AccessoI VALUES("IDin7","vano2",0,"edif2","Nord");
INSERT INTO AccessoI VALUES("IDin7","vano3",0,"edif2","Sud");
INSERT INTO AccessoI VALUES("IDin8","vano3",0,"edif2","Est");
INSERT INTO AccessoI VALUES("IDin8","vano4",0,"edif2","Ovest");

CALL topologiaEdificio("edif1"); 

/* Popolamento e test Operazione 3 */
INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO Rischio     VALUE("Sismico", "2023-01-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-05",0.4,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-10",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-20",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-10",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-20",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2022-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2021-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2020-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2019-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2019-09-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2018-02-25",0.6,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2018-10-25",0.6,"Italia");

CALL rischiAnnui("edif1");

/* Popolamento e test Operazione 4 */
INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	    VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO CapoCantiere    VALUE("1111111111111111",10,3);

CALL nuovoOperaio("aaaaaaaaaaaaaaaa",8,"1111111111111111");
CALL nuovoOperaio("bbbbbbbbbbbbbbbb",8,"1111111111111111");
CALL nuovoOperaio("cccccccccccccccc",8,"1111111111111111");

INSERT INTO Progetto        VALUES("ppppp",TRUE,"2023-02-01","2023-02-11","2023-02-14","2023-03-14","edif1");

INSERT INTO Stadio          VALUES("2023-02-14","2023-02-24","2023-02-24",0,"ppppp");
INSERT INTO Stadio          VALUES("2023-02-25","2023-03-02","2023-03-02",0,"ppppp");
INSERT INTO Stadio          VALUES("2023-03-03","2020-0-13","2023-03-13",0,"ppppp");

INSERT INTO Turno           VALUES("2023-02-14","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-14","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-15","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-15","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-16","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-16","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-17","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-17","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-18","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-18","1111111111111111","Pomeridiano","2023-02-14","ppppp");

INSERT INTO Turno           VALUES("2023-02-20","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-20","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-21","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-21","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-22","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-22","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-23","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-23","1111111111111111","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-24","1111111111111111","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-24","1111111111111111","Pomeridiano","2023-02-14","ppppp");


INSERT INTO Turno           VALUES("2023-02-14","aaaaaaaaaaaaaaaa","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-15","aaaaaaaaaaaaaaaa","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-16","aaaaaaaaaaaaaaaa","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-17","aaaaaaaaaaaaaaaa","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-18","aaaaaaaaaaaaaaaa","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-20","aaaaaaaaaaaaaaaa","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-21","aaaaaaaaaaaaaaaa","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-22","aaaaaaaaaaaaaaaa","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-23","aaaaaaaaaaaaaaaa","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-24","aaaaaaaaaaaaaaaa","Pomeridiano","2023-02-14","ppppp");

INSERT INTO Turno           VALUES("2023-02-14","bbbbbbbbbbbbbbbb","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-15","bbbbbbbbbbbbbbbb","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-16","bbbbbbbbbbbbbbbb","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-17","bbbbbbbbbbbbbbbb","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-18","bbbbbbbbbbbbbbbb","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-20","bbbbbbbbbbbbbbbb","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-21","bbbbbbbbbbbbbbbb","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-22","bbbbbbbbbbbbbbbb","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-23","bbbbbbbbbbbbbbbb","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-24","bbbbbbbbbbbbbbbb","Pomeridiano","2023-02-14","ppppp");

INSERT INTO Turno           VALUES("2023-02-14","cccccccccccccccc","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-15","cccccccccccccccc","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-16","cccccccccccccccc","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-17","cccccccccccccccc","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-18","cccccccccccccccc","Pomeridiano","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-20","cccccccccccccccc","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-21","cccccccccccccccc","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-22","cccccccccccccccc","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-23","cccccccccccccccc","Mattutino","2023-02-14","ppppp");
INSERT INTO Turno           VALUES("2023-02-24","cccccccccccccccc","Mattutino","2023-02-14","ppppp");


INSERT INTO Responsabile    VALUES("rrrrrrrrrrrrrrrr",100);

INSERT INTO Lavoro          VALUES("lav01","Eliminazione intonaco danneggiato","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");
INSERT INTO Lavoro          VALUES("lav02","Spazzolatura","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");
INSERT INTO Lavoro          VALUES("lav03","Mettere intonaco nuovo","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");
INSERT INTO Lavoro          VALUES("lav04","Rifinitura","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");
INSERT INTO Lavoro          VALUES("lav05","Fare Tracce","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");
INSERT INTO Lavoro          VALUES("lav06","Chiudere Tracce","rrrrrrrrrrrrrrrr","2023-02-14","ppppp");


INSERT INTO LavoriTurno     VALUES(8,4,"lav01",NULL,"2023-02-14","1111111111111111","Mattutino");
INSERT INTO LavoriTurno     VALUES(14,4,"lav01",NULL,"2023-02-14","1111111111111111","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(8,4,"lav02",NULL,"2023-02-15","1111111111111111","Mattutino");
INSERT INTO LavoriTurno     VALUES(14,4,"lav02",NULL,"2023-02-15","1111111111111111","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(8,4,"lav03",NULL,"2023-02-16","1111111111111111","Mattutino");
INSERT INTO LavoriTurno     VALUES(14,4,"lav03",NULL,"2023-02-16","1111111111111111","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(8,4,"lav03",NULL,"2023-02-17","1111111111111111","Mattutino");
INSERT INTO LavoriTurno     VALUES(14,4,"lav03",NULL,"2023-02-17","1111111111111111","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(8,4,"lav04",NULL,"2023-02-18","1111111111111111","Mattutino");
INSERT INTO LavoriTurno     VALUES(14,4,"lav04",NULL,"2023-02-18","1111111111111111","Pomeridiano");

INSERT INTO LavoriTurno     VALUES(9,4,"lav01","1111111111111111","2023-02-14","aaaaaaaaaaaaaaaa","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav02","1111111111111111","2023-02-15","aaaaaaaaaaaaaaaa","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav03","1111111111111111","2023-02-16","aaaaaaaaaaaaaaaa","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav03","1111111111111111","2023-02-17","aaaaaaaaaaaaaaaa","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav04","1111111111111111","2023-02-18","aaaaaaaaaaaaaaaa","Mattutino");

INSERT INTO LavoriTurno     VALUES(9,4,"lav01","1111111111111111","2023-02-14","bbbbbbbbbbbbbbbb","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav02","1111111111111111","2023-02-15","bbbbbbbbbbbbbbbb","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav03","1111111111111111","2023-02-16","bbbbbbbbbbbbbbbb","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav03","1111111111111111","2023-02-17","bbbbbbbbbbbbbbbb","Mattutino");
INSERT INTO LavoriTurno     VALUES(9,4,"lav04","1111111111111111","2023-02-18","bbbbbbbbbbbbbbbb","Mattutino");

INSERT INTO LavoriTurno     VALUES(14,4,"lav01","1111111111111111","2023-02-14","cccccccccccccccc","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(14,4,"lav02","1111111111111111","2023-02-15","cccccccccccccccc","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(14,4,"lav03","1111111111111111","2023-02-16","cccccccccccccccc","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(14,4,"lav03","1111111111111111","2023-02-17","cccccccccccccccc","Pomeridiano");
INSERT INTO LavoriTurno     VALUES(14,4,"lav04","1111111111111111","2023-02-18","cccccccccccccccc","Pomeridiano");

CALL leggiBustaPaga("aaaaaaaaaaaaaaaa",@BP);
SELECT @BP;

/* Popolamento e test Operazione 5 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Progetto        VALUES("ppppp",TRUE,"2020-01-01","2020-01-11","2020-01-14","2020-02-14","edif1");

INSERT INTO Stadio          VALUES("2020-01-14","2020-01-24","2020-01-24",0,"ppppp");
INSERT INTO Stadio          VALUES("2020-01-25","2020-02-02","2020-02-02",0,"ppppp");
INSERT INTO Stadio          VALUES("2020-02-03","2020-0-13","2020-02-13",0,"ppppp");

INSERT INTO Responsabile    VALUES("rrrrrrrrrrrrrrrr",100);

INSERT INTO Lavoro          VALUES("lav01","Eliminazione intonaco danneggiato","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav02","Spazzolatura","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav03","Mettere intonaco nuovo","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav04","Cambio piastrelle pavimento","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");

INSERT INTO Materiale       VALUES("L0001","fornitore1","Intonaco",6,"2020-01-14","lav03","Parete E","vano4",0,"edif1");
INSERT INTO Materiale       VALUES("L0002","fornitore1","Intonaco",6,"2020-01-14","lav03","Parete S","vano1",1,"edif1");
INSERT INTO Materiale       VALUES("L0003","fornitore1","Intonaco",6,"2020-01-14","lav03","Soffitto","vano3",1,"edif1");
INSERT INTO Materiale       VALUES("L0004","fornitore2","Piastrella",75,"2020-01-14","lav04","Pavimento","vano1",0,"edif1");
INSERT INTO Materiale       VALUES("L0005","fornitore2","Piastrella",53,"2020-01-14","lav04","Pavimento","vano2",0,"edif1");
INSERT INTO Materiale       VALUES("L0006","fornitore2","Piastrella",120,"2020-01-14","lav04","Pavimento","vano3",0,"edif1");
INSERT INTO Materiale       VALUES("L0007","fornitore2","Piastrella",53,"2020-01-14","lav04","Pavimento","vano4",0,"edif1");

INSERT INTO Intonaco		VALUES("L0001","fornitore1","Civile",1.5,2);
INSERT INTO Intonaco		VALUES("L0002","fornitore1","Civile",1.5,2);
INSERT INTO Intonaco		VALUES("L0003","fornitore1","Civile",1.5,2);
INSERT INTO Piastrella      VALUES("L0004","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0005","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0006","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0007","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");

CALL costoMaterialiStadio ("ppppp","2020-01-14",@costo);
SELECT @costo;

/* Popolamento e Test Operazione 6 */

INSERT INTO CapoCantiere    VALUE("1111111111111111",10,1);

-- va abuon fine
CALL nuovoOperaio("aaaaaaaaaaaaaaaa",10,"1111111111111111");

-- non va a buon fine
CALL nuovoOperaio("bbbbbbbbbbbbbbbb",10,"1111111111111111");

/* Popolamento Operazione 7 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);
INSERT INTO Edificio	VALUES("edif2",TRUE,"Bilocale","Italia",43.5,10.3);

INSERT INTO Calamita 	VALUES("Italia","2023-01-24","Sismico",42,11);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");
INSERT INTO Pianta		VALUES(0,4,"edif2");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano1",4,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano2",3,3,6.5,0,"edif2",3);
INSERT INTO Vano		VALUES("vano3",4,3,4,0,"edif2",3);
INSERT INTO Vano		VALUES("vano4",4,3,3.5,0,"edif2",3);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif2",26,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif2",26,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif2",9,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif2",19.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif2",19.5,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif2",16,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif2",16,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif2",7.5,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif2",7.5,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif2",12,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif2",12,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif2",10,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif2",10,TRUE);

INSERT INTO Sensore		VALUES("sens1","Posizione",2,3.65,8,"Parete S","vano1",1,"edif1");
INSERT INTO Sensore		VALUES("sens2","Posizione",6.03,2.78,8,"Parete N","vano2",0,"edif2");

INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),5.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),8,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),10,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),6.5,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7.1,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),7.9,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.7,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),9.8,"sens2");

CALL valutaAlert("2023-01-24 00:00:00.0", "sens1", @edificio, @piano, @vano, @parte, @pericolosita);
SELECT @edificio, @piano, @vano, @parte, @pericolosita;


/* Popolamento e Test Operazione 8 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Progetto        VALUES("ppppp",TRUE,"2020-01-01","2020-01-11","2020-01-14","2020-02-14","edif1");

INSERT INTO Stadio          VALUES("2020-01-14","2020-01-24","2020-01-24",0,"ppppp");
INSERT INTO Stadio          VALUES("2020-01-25","2020-02-02","2020-02-02",0,"ppppp");
INSERT INTO Stadio          VALUES("2020-02-03","2020-0-13","2020-02-13",0,"ppppp");

INSERT INTO Responsabile    VALUES("rrrrrrrrrrrrrrrr",100);

INSERT INTO Lavoro          VALUES("lav01","Eliminazione intonaco danneggiato","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav02","Spazzolatura","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav03","Mettere intonaco nuovo","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");
INSERT INTO Lavoro          VALUES("lav04","Cambio piastrelle pavimento","rrrrrrrrrrrrrrrr","2020-01-14","ppppp");

INSERT INTO Materiale       VALUES("L0001","fornitore1","Intonaco",6,"2020-01-14","lav03","Parete E","vano4",0,"edif1");
INSERT INTO Materiale       VALUES("L0002","fornitore1","Intonaco",6,"2020-01-14","lav03","Parete S","vano1",1,"edif1");
INSERT INTO Materiale       VALUES("L0003","fornitore1","Intonaco",6,"2020-01-14","lav03","Soffitto","vano3",1,"edif1");
INSERT INTO Materiale       VALUES("L0004","fornitore2","Piastrella",75,"2020-01-14","lav04","Pavimento","vano1",0,"edif1");
INSERT INTO Materiale       VALUES("L0005","fornitore2","Piastrella",53,"2020-01-14","lav04","Pavimento","vano2",0,"edif1");
INSERT INTO Materiale       VALUES("L0006","fornitore2","Piastrella",120,"2020-01-14","lav04","Pavimento","vano3",0,"edif1");
INSERT INTO Materiale       VALUES("L0007","fornitore2","Piastrella",53,"2020-01-14","lav04","Pavimento","vano4",0,"edif1");

INSERT INTO Intonaco		VALUES("L0001","fornitore1","Civile",1.5,2);
INSERT INTO Intonaco		VALUES("L0002","fornitore1","Civile",1.5,2);
INSERT INTO Intonaco		VALUES("L0003","fornitore1","Civile",1.5,2);
INSERT INTO Piastrella      VALUES("L0004","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0005","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0006","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");
INSERT INTO Piastrella      VALUES("L0007","fornitore2","Nessuno",13,"Gres Porcellanato",4,20,0.3,"Colla in polvere");

CALL materialiLavoro("lav04");


/* Popolamento e Test Analytics 1 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Rischio     VALUE("Sismico", "2023-01-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-05",0.4,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-10",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-20",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-10",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-20",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-25",0.6,"Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Sensore		VALUES("sens1","Posizione",2,3.65,8,"Parete S","vano1",1,"edif1");
INSERT INTO Sensore		VALUES("sens2","Posizione",6.03,2.78,8,"Parete N","vano2",0,"edif1");
INSERT INTO Sensore		VALUES("sens3","Giroscopio",4,7.5,1,"Soffitto","vano3",0,"edif1");

INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),5.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),8,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),9.9,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),6.5,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7.1,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),7.9,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.7,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),9.8,"sens2");

INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-20"),0.5,0.75,0.6,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-21"),0.5,0.7,0.92,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-22"),0.53,0.69,1.3,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-23"),0.8,1.3,1.36,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-24"),1,1.42,2.1,"sens3");

CALL consigliIntervento ("edif1");


/* Popolamento e Test Analytics 2 */

INSERT INTO AreaGeografica	VALUES("Italia");

INSERT INTO Rischio     VALUE("Sismico", "2023-01-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-05",0.4,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-10",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-01-20",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-01",0.5,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-10",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-20",0.7,"Italia");
INSERT INTO Rischio     VALUE("Sismico", "2023-02-25",0.6,"Italia");

INSERT INTO Edificio	VALUES("edif1",TRUE,"Capannone industriale","Italia",45,12);

INSERT INTO Pianta		VALUES(0,4,"edif1");
INSERT INTO Pianta		VALUES(1,4,"edif1");

INSERT INTO Vano		VALUES("vano1",5,4,15,0,"edif1",4);
INSERT INTO Vano		VALUES("vano2",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano3",15,4,8,0,"edif1",4);
INSERT INTO Vano		VALUES("vano4",15,4,3.5,0,"edif1",4);
INSERT INTO Vano		VALUES("vano1",8,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano2",4,4,15,1,"edif1",4);
INSERT INTO Vano		VALUES("vano3",8,4,15,1,"edif1",4);

INSERT INTO Parte 		VALUES("Parete S","vano1",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",0,"edif1",20,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",0,"edif1",75,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano2",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano2",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano3",0,"edif1",32,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",0,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano3",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",0,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Parete S","vano4",0,"edif1",14,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano4",0,"edif1",14,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano4",0,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete E","vano4",0,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano4",0,"edif1",52.5,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano4",0,"edif1",52.5,FALSE);

INSERT INTO Parte 		VALUES("Parete S","vano1",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete N","vano1",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano1",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano1",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano1",1,"edif1",120,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete O","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano2",1,"edif1",16,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano2",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano2",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete S","vano3",1,"edif1",60,FALSE);
INSERT INTO Parte 		VALUES("Parete N","vano3",1,"edif1",60,TRUE);
INSERT INTO Parte 		VALUES("Parete O","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Parete E","vano3",1,"edif1",32,TRUE);
INSERT INTO Parte 		VALUES("Pavimento","vano3",1,"edif1",120,FALSE);
INSERT INTO Parte 		VALUES("Soffitto","vano3",1,"edif1",120,TRUE);

INSERT INTO Sensore		VALUES("sens1","Posizione",2,3.65,8,"Parete S","vano1",1,"edif1");
INSERT INTO Sensore		VALUES("sens2","Posizione",6.03,2.78,8,"Parete N","vano2",0,"edif1");
INSERT INTO Sensore		VALUES("sens3","Giroscopio",4,7.5,1,"Soffitto","vano3",0,"edif1");
INSERT INTO Sensore		VALUES("sens4","Accelerometro",4,7.5,1,"Soffitto","vano3",0,"edif1");
INSERT INTO Sensore		VALUES("sens5","Giroscopio",7.5,2,1,"Soffitto","vano2",1,"edif1");
INSERT INTO Sensore		VALUES("sens6","Accelerometro",7.5,2,1,"Soffitto","vano2",1,"edif1");

INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),5.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),8,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.5,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),10,"sens1");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-20"),6.5,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-21"),7.1,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-22"),7.9,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-23"),8.7,"sens2");
INSERT INTO Posizione 	VALUES(TIMESTAMP("2023-01-24"),9.8,"sens2");

INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-20"),0.5,0.75,0.6,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-21"),0.5,0.7,0.92,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-22"),0.53,0.69,1.3,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-23"),0.8,1.3,1.36,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-24"),1,1.42,2.1,"sens3");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-20"),0.62,0.77,0.68,"sens5");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-21"),0.62,0.86,1,"sens5");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-22"),0.7,0.95,1.5,"sens5");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-23"),0.95,1.45,1.79,"sens5");
INSERT INTO Giroscopio 	VALUES(TIMESTAMP("2023-01-24"),1.21,1.7,2.4,"sens5");

INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-20"),0.5,0.75,0.6,"sens4");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-21"),0.5,0.7,0.92,"sens4");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-22"),0.53,0.69,1.3,"sens4");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-23"),0.8,1.3,1.36,"sens4");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-24"),1,1.42,2.1,"sens4");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-20"),0.62,0.77,0.68,"sens6");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-21"),0.62,0.86,1,"sens6");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-22"),0.7,0.95,1.5,"sens6");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-23"),0.95,1.45,1.79,"sens6");
INSERT INTO Accelerometro VALUES(TIMESTAMP("2023-01-24"),1.21,1.7,2.4,"sens6");

CALL stimaDanni("edif1", 7, @danni);
SELECT @danni;