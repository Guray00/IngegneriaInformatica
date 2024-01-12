function init(){
    let bottone = document.querySelector("input[type='submit']");
    bottone.addEventListener("click", invia);
}

function invia(e){
    let codice = document.querySelector("input[name='codice']");
    if(!codice.validity.valid||codice.value==="")
        e.preventDefault();
    
}