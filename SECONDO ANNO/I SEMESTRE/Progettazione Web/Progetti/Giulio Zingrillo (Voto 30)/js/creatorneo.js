function init(){
    let bottone = document.querySelector("input[type='submit']");
    bottone.addEventListener("click", invia);
}

function invia(e){
    let nome = document.querySelector("input[name='nome']");
    let inizio = document.querySelector("input[name='inizio']");
    let partitesettimana = document.querySelector("input[name='partitesettimana']");
    let orapartite = document.querySelector("input[name='orapartite']");
    let campo = document.querySelector("input[name='campo']");
    if(!nome.validity.valid||nome.value===""||inizio.value===""||!partitesettimana.validity.valid||partitesettimana.value===""||orapartite.value===""||!campo.validity.valid||campo.value==="")
        e.preventDefault();
    
}