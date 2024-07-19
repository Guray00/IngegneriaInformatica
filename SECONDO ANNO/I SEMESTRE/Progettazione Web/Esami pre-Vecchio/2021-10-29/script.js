let vincenti = [];
let coppie_l = [];
let coppie_n = [];
let vincite = [5, 10, 20, 100, 1000, 10000];
let index = 0;
let table = document.querySelectorAll(".giocatore td");

function scopri(){
    document.getElementById("scopri").disabled = true;
    document.getElementById("gratta").disabled = false;
    
    // genera 5 lettere minuscole con cui riempire la parte delle lettere vincenti
    for(let i = 0; i < 5; i++){
        aggiungi_lettera(vincenti);
        document.getElementsByTagName("td")[i].style.background = 'red';
    }
    // riempi lettere vincenti
    const out = document.querySelectorAll(".lv td");
    
    for(let i = 0; i < out.length;i++){
        out[i].textContent = vincenti[i];
    }
}


function gratta(){
    aggiungi_lettera(coppie_l);
    aggiungi_vincita(coppie_n);
    // console.log(coppie_l);
    // console.log(coppie_n);
    // console.log(index);
    if(index == 5){
        index = 10;
    }

    table[index].textContent = coppie_l[coppie_l.length-1];
    table[index].style.background = 'white';
    table[index+5].textContent = coppie_n[coppie_n.length-1];
    table[index+5].style.background = 'white';
    
    index++;
    if(index > 14)
        fine_gioco();
}


function fine_gioco(){
    document.getElementById("gratta").disabled = true;

    // calcola la vincita
    let vincita = 0;
    for(let i = 0;i < coppie_l.length;i++){
        for(let j = 0;j < vincenti.length;j++){
            if(coppie_l[i] == vincenti[j]){
                vincita += coppie_n[i];
            }
        }
    }
    console.log("Vincita: " + vincita + " euro");

    // crea nuova finestra
    _result = window.open("", "Result", "width=300, height=200");
    _result.document.open();
    _result.document.write('<link rel="stylesheet" href="style.css"><article> Hai vinto ' + vincita + ' euro </article>')
    setTimeout(function(){
        _result.close();
        vincenti = [];
        index = 0;
        coppie_l = [];
        coppie_n = [];
        document.getElementById("scopri").disabled = false;

        // cancel all cells
        let cell = document.getElementsByTagName("td");
        for(let i = 0; i < cell.length;i++){
            cell[i].textContent = '';
            cell[i].style.background = "green";
        }
    },3000);

    return;
}




function controlla_lettera(array, lettera){
    for(let i = 0; i < array.length;i++){
        if(lettera == array[i])
        return true;
    }
    return false;
}

function aggiungi_lettera(array){
    let l = String.fromCharCode(97+Math.floor(Math.random() * 26));
    if(!controlla_lettera(array, l)){
        array.push(l);
    }else{
        aggiungi_lettera(array);
    }
}

function aggiungi_vincita(array){
    let a = Math.floor(Math.random()*6);
    array.push(vincite[a]);
}