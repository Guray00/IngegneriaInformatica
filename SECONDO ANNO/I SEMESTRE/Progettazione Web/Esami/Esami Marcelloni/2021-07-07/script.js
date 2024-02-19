// tabella prenotazioni di un servizio
class Servizio{
    constructor(name){
        this.name = name;
        this.prenotazioni;

        this.crea_struttura();
    }
    crea_struttura(){
        this.prenotazioni = [];
        let ore = 12;
        for(let i = 0; i <= ore;i++){
            let data = [];
            let prenotazione = [i+8, data];
            for(let j = 0; j < 3;j++){
                data[j] = null;
            }
            this.prenotazioni.push(prenotazione);
        }
    }
}

/*
struttura:
prenotazioni(array):[
    ora, (array)[cognome, nome, telefono]
]  
*/


function create_table(prenotazioni = null){

    let container = document.querySelector(".table-container");
    let table = document.createElement("table");
    container.appendChild(table);
    
    let first_row = document.createElement("tr");
    let head = document.createElement("th")
    head.textContent = 'Ora';
    first_row.appendChild(head);

    head = document.createElement("th")
    head.textContent = 'Cognome';
    first_row.appendChild(head);

    head = document.createElement("th")
    head.textContent = 'Nome';
    first_row.appendChild(head);

    head = document.createElement("th")
    head.textContent = 'Telefono';
    first_row.appendChild(head);

    table.appendChild(first_row);

    for(let i = 0; i <= 12;i++){
        let row = document.createElement("tr");
        for(let j = 0; j < 4;j++){
            let field = document.createElement("td");
            row.appendChild(field);
            if(j == 0){
                field.textContent = i+8;
            }else{
                if(prenotazioni){
                    if(prenotazioni[i][1][j-1]){
                        field.textContent = prenotazioni[i][1][j-1];
                    }else{
                        field.textContent = '-';
                    }
                }else{
                    field.textContent = '-';
                }
            }
            
        }
        table.appendChild(row);
    }
}


create_table();


let servizi = [
    new Servizio('servizio_1'),
    new Servizio('servizio_2'),
    new Servizio('servizio_3')
]

function inserisci(n_servizio){
    // controllo input
    let cognome = document.querySelector("#cognome").value;
    let nome = document.querySelector("#nome").value;
    let telefono = document.querySelector("#telefono").value;
    // check inputs
    // empty
    if(cognome == '' || nome == '' || telefono == ''){
        alert("Riempi tutti i campi!");
        return;
    }
    // nome e cognome solo lettere
    if(nome.match(/[^a-zA-Z]/) != null || cognome.match(/[^a-zA-Z]/g) != null){
        alert("Usa solo lettere per Nome e Cognome!");
        return;
    }
    // telefono solo numeri
    if(telefono.match(/[^0-9]/) != null){
        alert("Usa solo numeri per Telefono");
        return;
    }
    

    // ottengo il nome del servizio 
    let servizio = servizi[n_servizio-1];
    
    // ottengo l'ora selezionata
    let target = "." + servizio.name + " #ora";
    let ora = document.querySelector(target).value
    
    
    // ottengo il riferimento all'elemento da modificare
    let option = document.querySelector(target).querySelectorAll('option')[ora-8];
    
    // disattiva ora selezionata
    option.disabled = true;

    // seleziono la prenotazione da aggiungere
    let prenotazione = servizio.prenotazioni[ora-8];
  
    prenotazione[1][0] = cognome;
    prenotazione[1][1] = nome;
    prenotazione[1][2] = telefono;

    alert("Prenotazione effettuata!")
}

function cancella(n_servizio){
    // prendo il cognome inserito
    let cognome = document.querySelector("#cognome").value;
    // prendo le prenotazioni del servizio
    let servizio = servizi[n_servizio-1];
    let prenotazioni = servizio.prenotazioni;
    // cerco il cognome nel servizio
    let ora;
    for(let i = 0; i < prenotazioni.length;i++){
        if(prenotazioni[i][1][0] == cognome){
            ora = i+8;
            let p = prenotazioni[i][1];
            // cancello la prenotazione
            p[0] = null;
            p[1] = null;
            p[2] = null;
        }
    }
    // riattivo l'ora per la prenotazione
    // ottengo il riferimento all'elemento da modificare
    let target = "." + servizio.name + " #ora";
    let option = document.querySelector(target).querySelectorAll('option')[ora-8];
    // disattiva ora selezionata
    option.disabled = false;

    alert("Prenotazione cancellata!")
    
}

function destroy_table(){
    let table = document.querySelector("table");
    table.remove();
}


function mostra_servizio(n){
    let p = servizi[n-1];
    let nome;
    switch(p.name){
        case 'servizio_1':
            nome = 'Servizio 1';
            break;
        case 'servizio_2':
            nome = 'Servizio 2';
            break;
        case 'servizio_3':
            nome = 'Servizio 3';
            break;
    }

    // mostra il nome
    document.querySelector(".nome-servizio").textContent = nome;

    p = p.prenotazioni
    
    // elimina la tabella
    destroy_table();
    // e la ricrea
    create_table(p);
}