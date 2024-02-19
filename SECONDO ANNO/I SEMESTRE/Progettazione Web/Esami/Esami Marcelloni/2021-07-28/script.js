// creazione tabella
function create_table(dim){
    let table = document.querySelector("tbody");

    for(let i = 0; i < dim;i++){
        table.appendChild(document.createElement('tr'));
        let row = document.querySelectorAll("tr")[i];
        for(let j = 0; j < dim;j++){
            row.appendChild(document.createElement('td'));
        }
    }

}



function game(){
    // set up
    console.log('Inizio del gioco');


    // numeri da cui estrarre
    let numbers = [1, 2, 3, 4];
    let n = numbers.length+1;
    
    // numero di tentativi
    let tentativi = 4;

    // elenco di tutte le celle disponibili
    let cells = document.querySelectorAll("td");

    // array coppie cella-numero
    let celle_scelte = {
        numero: [],
        casella: []
    };

    let timer;


    // reset tentativi
    document.querySelector(".tentativi").textContent = '';

    // colora le celle di blu
    for(let i = 0; i < cells.length;i++){
        cells[i].style.backgroundColor = 'blue';
        cells[i].textContent = '';
    }

    
    // contatore successi
    let successi = 0;
    // contatore errori
    let errori = 0;

    // attivazione del tasto start
    document.querySelector(".start").disabled = false;

    

    //start_game(numbers, cells, tentativi, numbers.length+1,  celle_scelte);

    document.querySelector(".start").addEventListener('click', () => {   
        // inizio
        start_game();
    });

    // start
    function start_game(){
        // scrivo il numero di tenativi
        document.querySelector(".tentativi").textContent = tentativi;

        // disattivazione del tasto start
        document.querySelector(".start").disabled = true;


        cells_loop();
    }

    function cells_loop(){
        // contatore
        n--;

        // cancello la casella illuminata in precedenza
        // cancellando tutte le celle scelte ogni volta
        for(let i = 0; i < cells.length;i++){
            cells[i].textContent = '';
            cells[i].style.backgroundColor = 'blue';
        }

        // uscita dal loop
        if(n == 0){
            player_time();
            return;
        }else if(n > 0){
            // crea coppie cella-numero
            let x;
            do{
                x = Math.floor(Math.random()*cells.length);
            }while(isPresent(x, celle_scelte.casella));

            // scelgo un numero a caso
            let y = Math.floor(Math.random()*numbers.length);
            // in questo caso estraggo il numero dall'array
            y = numbers.splice(y,1)[0];

            // inserisco nelle celle scelte dal gioco
            celle_scelte.numero.push(y);
            celle_scelte.casella.push(x);

            // mando sullo schermo
            cells[x].textContent = y;
            cells[x].style.backgroundColor = 'yellow';

            // ricorsione
            if(n != 0){
                timer = setTimeout(cells_loop, 1000);
            }
        }else{
            return;
        }
    }

    function isPresent(a, array){
        for(let i = 0; i < array.length;i++){
            if(array[i] == a)
            return true;
        }
        return false;
    }


    // player input
    function player_time(){
        console.log("tocca al giocatore");

        // riordino array celle vincenti
        for(let i = 0; i < celle_scelte.numero.length-1;i++){
            for(let j = 0; j < celle_scelte.numero.length-1;j++){
                if(celle_scelte.numero[j] > celle_scelte.numero[j+1]){
                    // scambio
                    let tmp = celle_scelte.numero[j];
                    celle_scelte.numero[j] = celle_scelte.numero[j+1];
                    celle_scelte.numero[j+1] = tmp;

                    // scambio anche le caselle corrispondenti
                    tmp = celle_scelte.casella[j];
                    celle_scelte.casella[j] = celle_scelte.casella[j+1];
                    celle_scelte.casella[j+1] = tmp;
                }
            }
        }
        console.log(celle_scelte);

        // abilito il click sulle celle
        for(let i = 0; i < cells.length;i++){
            cells[i].addEventListener('click', click);
        }
    }

    // event handler
    function click(){
        // console.log(this);
        // console.log(cells[celle_scelte.casella[0]]);
    
        if(this.style.backgroundColor == 'green'){
            return;
        }
    
        if( this == cells[celle_scelte.casella[0]]){
            console.log("trovata");
            // colora la cella di verde e riscrive il numero
            cells[celle_scelte.casella[0]].style.backgroundColor = 'green';
            cells[celle_scelte.casella[0]].textContent = celle_scelte.numero[0];
            successi++;
            if(successi >= 4){
                fine('vinto');
            }
            // elimina da celle_scelte il primo valore
            celle_scelte.casella.splice(0, 1);
            celle_scelte.numero.splice(0, 1);
            console.log(celle_scelte);
        }else{
            console.log("errore");
        
            if(this.style.backgroundColor == 'red'){
                return;
            }
    
            // colora la cella di rosso
            this.style.backgroundColor = 'red';
            errori++;
            if(errori >= tentativi){
                fine('perso');
            }
        }
    
        document.querySelector(".tentativi").textContent = tentativi - errori;    
    }

    // fine
    function fine(esito){
        console.log("Fine partita");

        // disattivazione click sulle celle
        for(let i = 0; i < cells.length;i++){
            cells[i].removeEventListener('click', click);
        }

    
        // apri la finestra di riepilogo
        let _result = window.open("", "Riepilogo", "width = 300, height = 200");
        _result.document.open();
        if(esito == 'vinto')
            _result.document.write("Bravo, hai commesso " + errori + " errori!");
        else
            _result.document.write("Hai perso!");
        _result.document.close();
    
        
        // chiude la finestra dopo 5 secondi
        setTimeout(function(){
            _result.close();

            // restart
            game();
        }, 5000);   
    }
}