use PAS;

-- insert into muro values(-10, 0, 0, 0, 1, 1, null),(-9, 0, 0, 1, 1, 1, null),(-8, -1, -1, 1, 1, 1, null),(-7, -1, 1, 10001, 1, 1, null); delete from muro where id < 0;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

select superficie_vano(2), superficie_piano(0, 1), superficie_edificio(1), superficie_edificio(2), superficie_edificio(3); 

select costo_lavori_edificio(1);

call calcola_tutti_stipendi(2022, 9);
select stipendio(2022, 9, 'RSSMRA70A01H501S');

-- insert_impiego già testata abbondantemente nel popolamento

call conta_edifici_con_lavori('2022-09-20', @a, @b, @c, @d);
select @a, @b, @c, @d;
call conta_edifici_con_lavori('2122-11-01', @a, @b, @c, @d);
select @a, @b, @c, @d;

call stadio_in_ritardo('2022-10-01');

call stato_parete(14, 0, @a, @b); -- bagno di daria, dentro
select @a, @b;
call stato_parete(14, 1, @a, @b); -- bagno di daria, fuori
select @a, @b;
call stato_parete(13, 0, @a, @b); -- bagno di daria, dentro
select @a, @b;
call stato_parete(13, 1, @a, @b); -- camera di daria
select @a, @b;

call stato_lavoratori("2022-09-20 09:00:00");
call stato_lavoratori("2022-09-20 04:20:00");

select *, orientamento_apertura(muro, sinistra, destra) from apertura;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

call stato_edificio(1, '2000-01-02 00:00:00', @generale, @a, @b, @c);
select @generale, @a, @b, @c;
call consigli_intervento(1, '2000-01-02 00:00:00');

call stato_edificio(1, '2022-09-27 12:00:00', @gen, @a, @b, @c);
select @gen, @a, @b, @c;

select * from misura where sensore = 9;

select costo_lavori_edificio(3);

call consigli_intervento(1, '2022-09-27 12:00:00');
call stima_danni_terremoto(9, 7, 43, 10);

select stima_gravita('2000-01-01 09:57:00', 'Terremoto', 43, 9, 'Toscana');

select * from calamita;
select * from danneggiamento;

delete M from misura M left outer join alert A
    on M.sensore = A.sensore and M.timestamp between A.timestamp - interval 69 minute and A.timestamp + interval 69 minute
where M.timestamp < current_timestamp - interval 1 week and A.sensore is null;

