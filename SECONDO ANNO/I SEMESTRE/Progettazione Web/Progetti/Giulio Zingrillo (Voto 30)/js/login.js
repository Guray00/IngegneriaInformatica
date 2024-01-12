function init(){
    let bottone = document.querySelector("input[type='submit']");
    bottone.addEventListener("click", invia);
}

function invia(e){
    let username = document.querySelector("input[name='username']");
    let password = document.querySelector("input[name='password']");
    if(username.validity.invalid||password.validity.invalid||username.value===""||password.value==="")
        e.preventDefault();
    
}