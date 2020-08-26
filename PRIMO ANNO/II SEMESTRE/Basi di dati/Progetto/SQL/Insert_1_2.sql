use mydb;
insert into Prodotto values
(10100, 'Apple', 'iPhone4', 'Smartphone', 199.90, 399.95),
(10200, 'Apple', 'iPhone5', 'Smartphone', 250.00, 449.98),
(10300, 'Apple', 'iPhone6', 'Smartphone', 300.00, 499.99),
(10400, 'Samsung', 'Galaxy4', 'Smartphone', 200.00, 399.96),
(10500, 'Samsung', 'Galaxy5', 'Smartphone', 250.00, 449.50),
(10600, 'Samsung', 'Galaxy6', 'Smartphone', 300.00, 499.60),
(10700, 'Samsung', 'GalaxyNote', 'Smartphone', 350.00, 549.99);

insert into Punto_Vendita values
(1000, 'Roma, 03043, 53', 1776300178),
(2000, 'Milano, 03343, 32', 1774365385),
(3000, 'Torino, 50211, 113', 1637536423);

insert into Dipendente values
('RSSMRI94E12H501I', 'Mario', 'Rossi', '2010-04-01', 'Vendita'),
('BNCCRL94E12H501I', 'Carlo', 'Bianchi', '2011-05-01', 'Riparazion'),
('VRDFRN94E12H501I', 'Franco', 'Verdi', '2012-06-01', 'Gestione'),
('NRILCA94E12H501I', 'Luca', 'Neri', '2012-07-02', 'Vendita'),
('RSIPLO94E12H501I', 'Paolo', 'Rossi', '2013-04-12', 'Riparazion'),
('BNCMRI94E12H501I', 'Mario', 'Bianchi', '2012-06-13', 'Gestione'),
('VRDBRN94E12H501I', 'Bruno', 'Verdi', '2013-06-12', 'Vendita'),
('NRIGVN94E12H501I', 'Giovanni', 'Neri', '2014-12-03', 'Riparazion'),
('RSISMN94E12H501I', 'Simone', 'Rossi', '2014-11-04', 'Gestione');

insert into Lista_Dipendenti values
('RSSMRI94E12H501I', 1000),
('BNCCRL94E12H501I', 1000),
('VRDFRN94E12H501I', 1000),
('NRILCA94E12H501I', 2000),
('RSIPLO94E12H501I', 2000),
('BNCMRI94E12H501I', 2000),
('VRDBRN94E12H501I', 3000),
('NRIGVN94E12H501I', 3000),
('RSISMN94E12H501I', 3000);

insert into Magazzino values
(10200, 1000, 35),
(10300, 1000, 62),
(10400, 1000, 14),
(10500, 1000, 26),
(10600, 1000, 23),
(10700, 1000, 72),
(10100, 2000, 2),
(10200, 2000, 25),
(10300, 2000, 27),
(10400, 2000, 28),
(10500, 2000, 84),
(10600, 2000, 26),
(10700, 2000, 16),
(10100, 3000, 84),
(10200, 3000, 27),
(10300, 3000, 95),
(10400, 3000, 27),
(10500, 3000, 27),
(10600, 3000, 58),
(10700, 3000, 37);

insert into Cliente values
('RSSCRL94E22H531I', 'Carlo', 'Rossi', 3492467391, 'Roma'),
('NRIMRI94E22H531I', 'Mario', 'Neri', 3492467392, 'Roma'),
('VRIMCE94E22H531I', 'Michele', 'Verdi', 3492467393, 'Milano'),
('BNCLCA94E22H531I', 'Luca', 'Bianchi', 3492467394, 'Milano');

insert into Modulo_Vendita values 
(20100, '2015-01-01', 850.00, 'RSSCRL94E22H531I'),
(20200, '2015-01-02', 450.00, 'VRIMCE94E22H531I'),
(20300, '2015-01-03', 450.00, 'BNCLCA94E22H531I'),
(20400, '2015-01-04', 900.00, 'NRIMRI94E22H531I');

insert into Lista_Vendite values
(20100, 'RSSMRI94E12H501I'),
(20200, 'NRILCA94E12H501I'),
(20300, 'VRDBRN94E12H501I'),
(20400, 'NRILCA94E12H501I');

insert into Modulo_Riparazione values
(30100, 'Garanzia', '2015-01-01', '2015-02-01', 'NRIMRI94E22H531I', 0.00, 'Completo'),
(30200, 'Batteria', '2015-01-02', '2015-02-02', 'VRIMCE94E22H531I', 10.00, 'Repair'),
(30300, 'Display', '2015-01-03', '2015-02-03', 'RSSCRL94E22H531I', 40.00, 'Completo'),
(30400, 'Microfono', '2015-01-04', '2015-02-04', 'BNCLCA94E22H531I', 5.00, 'Consegnato'),
(30500, 'Fusibile', '2015-01-05', '2015-02-05', 'RSSCRL94E22H531I', 2.00, 'Completo');

insert into Lista_Riparazioni values
('BNCCRL94E12H501I', 30100),
('BNCCRL94E12H501I', 30200),
('RSIPLO94E12H501I', 30300),
('NRIGVN94E12H501I', 30400),
('RSIPLO94E12H501I', 30500);

insert into Ordine values
(40100, '2015-05-01', 'VRDFRN94E12H501I'),
(40200, '2015-05-14', 'BNCMRI94E12H501I'),
(40300, '2015-06-01', 'RSISMN94E12H501I');

insert into Lista_Ordine values
(10200, 40100, 5),
(10300, 40100, 2),
(10400, 40100, 1),
(10300, 40200, 2),
(10500, 40300, 3);

insert into Lista_Prodotti_Vendita values
(20100, 10100, 1),
(20100, 10200, 1),
(20200, 10500, 1),
(20300, 10500, 1),
(20400, 10500, 2);


insert into Lista_Prodotti_Riparazione values
(10200, 30100),
(10100, 30200),
(10500, 30300),
(10500, 30400),
(10200, 30500);







