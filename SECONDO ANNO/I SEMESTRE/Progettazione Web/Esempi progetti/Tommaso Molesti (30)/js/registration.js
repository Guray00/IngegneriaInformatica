function init() {
    let bottone = document.querySelector("input[type='submit']");
    let email = document.querySelector("input[name='email']");
    let password = document.querySelector("input[name='password']");

    bottone.disabled = true;

    email.addEventListener("input", inputChange);
    password.addEventListener("input", inputChange);

}

function inputChange() {
    let bottone = document.querySelector("input[type='submit']");
    let email = document.querySelector("input[name='email']");
    let password = document.querySelector("input[name='password']");

    if (email.value && password.value && email.validity.valid && password.validity.valid) {
        bottone.disabled = false;
    } else {
        bottone.disabled = true;
    }
}

function invia(e){
    let email = document.querySelector("input[name='email']");
    let password = document.querySelector("input[name='password']");
    if(!email.validity.valid || email.value==="" || !password.validity.valid || password.value==="")
        e.preventDefault();
    
}