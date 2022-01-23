let l;

class Lista{
    constructor(){
        this.dim = 0;
        this.time = [];
        this.name = [];
    }
    add(input){
        // aggiunge un nuovo elemento in fondo alla coda


        this.time[this.dim] = this.dim * 5;
        this.name[this.dim] = input;
        
        // actual print
        let table = [document.querySelectorAll(".time-from-start")[this.dim], document.querySelectorAll(".cognome")[this.dim]];
        table[0].textContent = this.time[this.dim];
        table[1].textContent = this.name[this.dim];

        this.dim++;
    }

    remove(){
        // rimouve il primo elemento della coda
        this.name.splice(0,1);
        this.time.splice(0,1);
        //console.log(this);

        // sposta la coda verso l'alto
        for(let i = 0; i < this.dim;i++){
            let table = [document.querySelectorAll(".time-from-start")[i], document.querySelectorAll(".cognome")[i]];
            //console.log("time: " + table[0].textContent + ' ' + "cognome: " + table[1].textContent);
            //console.log("time: " + this.time[i]);
            table[0].textContent = this.time[i] != undefined ? this.time[i] : '-';
            table[1].textContent = this.name[i] != undefined ? this.name[i] : '-';
        }

        this.dim--;
    }
}

let list = new Lista();
// console.log(list);

document.querySelector(".inserisci").addEventListener("click", function(){
    // get input
    let input = document.querySelector("input").value;
    //console.log('input: ' + input);

    // clear input
    document.querySelector("input").value = '';

    // input check
    if(input == ''){
        return;
    }

    // aggiunge l'elemento
    list.add(input);
    //console.log(list);

    // se ci sono almeno 2 elementi in coda posso permettere il servizio
    if(list.dim >= 2){
        document.querySelector(".servi").disabled = false;
    }

    // coda piena
    if(list.dim >= 5){
        // inizio a servire la coda
        servizio();
    }
})


// aggiungo un event al tasto servi (in modo leggermente diverso rispetto a 'inserisci' ma con lo stesso risultato)
document.querySelector(".servi").addEventListener('click', servizio);


// si occupa di "elaborare" un singolo elemento della coda
function loop(){
    // se la coda è vuota fermo tutto ed esco
    if(list.dim === 0){
        clearInterval(l);
        reset();
        return;
    }
    console.log("nuovo servizio");
    // preleva dalla tabella e inserisce in servizio
    let serv = document.querySelector(".in-servizio p");
    serv.textContent = list.name[0];
    list.remove();

    // dopo tot secondi dall'inizio di ogni servizio cambio lo sfondo dell'elemento
    let y = setTimeout(color, 3000, 'yellow');
    let r = setTimeout(color, 4000, 'red');
    // torno al colore originale per il prossimo serivizio
    let w = setTimeout(color, 5000, 'white');
}


// avvia il servizio della coda
function servizio(){   
    console.log("Servizio iniziato");
    // disattiva tutti gli input
    let a = document.querySelectorAll("input, button");
    for(let i = 0; i < a.length;i++){
        a[i].disabled = true;
    }

    // avvia il timer + relativa scrittura sul documento
    start_timer();

    // esegue il primo servizio
    loop();
    // poi richiama il servizio ogni 5 secondi
    l = setInterval(loop, 5000);
}


// modifica lo sfondo dell'elemento
function color(color){
    document.querySelector(".in-servizio p").style.backgroundColor = color;
}


// si occupa di gestire la fine del servizio + reset degli elementi modificati
function reset(){
    // resetta l'elemento che mostra il servizio
    document.querySelector(".in-servizio p").textContent = '-';
    // riattiva il bottono inserisci e l'input
    document.querySelector(".inserisci").disabled = false;
    document.querySelector("input").disabled = false;

    
    console.log("Servizio completato con successo!");

    // Nuova finestra
    let _result = window.open("", "bho", "width=300, height=200");
    _result.document.open();
    _result.document.write("Servizio completato");
    _result.document.close();
    setTimeout(function(){
        _result.close();
    },5000);
}

// gestisce il timer (in reltà è un cronometro e non un timer)
function start_timer(){
    // setta il tempo massimo
    let max = list.time[list.dim - 1] + 5;
    console.log("Total time needed: " + max + " sec");

    // intervallo di aggiornamento (ms)
    let wait = 5;

    // Azzera i valori
    let sec = 0;
    let milli = 0;

    // incrementa il timer
    let timer = setInterval(() => {
        
        milli += wait;
        if(milli >= 1000){
            milli = 0;
            sec++;
        }
        document.querySelector(".time").textContent = sec + ' : ' + milli;

        // se si è raggiungo il tempo massimo resetta il timer
        if(sec == max){
            let t = document.querySelector(".time");
            t.textContent = '';
            clearInterval(timer);
        }  
    }, wait);
}


/* 
    NOTA:   Timer e gestione della coda, seppur con le tempistiche giuste potrebbero non essere esattamente allineati 
            visto che sono due cose gestite separatamente.
            Questo accade in particolare quando l'intervallo di aggiornamento del timer è troppo piccolo
            e il browser non riesce a richiamare la funzione esattamente con tale intervallo
            Si consiglia un intervallo non inferiore a 5 millisecondi
*/