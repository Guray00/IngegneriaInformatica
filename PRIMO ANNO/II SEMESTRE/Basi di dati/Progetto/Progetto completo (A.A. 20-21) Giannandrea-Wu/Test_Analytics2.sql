use Smarthome;
insert into Interazione(Dispositivo,Inizio,Fine,Consumo,Account,Potenza,Programma)
 values (1,'2021-08-31 12:19',null,null,'Paolo',null,null),(16,'2021-08-31 12:24',null,null,'Paolo',21,null), 
        (12,'2021-08-31 12:19',null,null,'Giovanna',null,13);
	
/* insert into Condizionamento (Condizionatore, Inizio, Account, Temperatura, Umidita, Fine)
values 	(1,'2021-08-31 12:33','Paolo', 20, 50, null);*/
        
insert into Illuminazione (Luce, Inizio, Fine, TemperaturaColore, Intensita, Account)
values	(3,'2021-08-31 12:21', null, 6000, 2, 'Francesco'),
        (4,'2021-08-31 12:41', null, 5000, 1, 'Giovanna'),
        (5,'2021-08-31 12:34', null, 5000, 1, 'Giovanna');
        
set @tempo = '2021-08-31 12:59';
call analytics_2();
SELECT * FROM Smarthome.Suggerimento;