function init(){
    let bottone = document.querySelector("input[type='submit']");
    bottone.addEventListener("click", invia);
}

function invia(e){
    let nome = document.querySelector("input[name='nome']");
    let cognome = document.querySelector("input[name='cognome']");
    let username = document.querySelector("input[name='username']");
    let password = document.querySelector("input[name='password']");
    if(!nome.validity.valid||nome.value===""||!cognome.validity.valid||cognome.value===""||!username.validity.valid||username.value===""||!password.validity.valid||password.value==="")
        e.preventDefault();
    
}