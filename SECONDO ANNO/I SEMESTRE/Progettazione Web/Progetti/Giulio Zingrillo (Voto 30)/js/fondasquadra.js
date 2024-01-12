function init(){
    let bottone = document.querySelector("input[type='submit']");
    bottone.addEventListener("click", invia);
}

function invia(e){
    let nome = document.querySelector("input[name='nome']");
    if(!nome.validity.valid||nome.value==="")
        e.preventDefault();
    
}