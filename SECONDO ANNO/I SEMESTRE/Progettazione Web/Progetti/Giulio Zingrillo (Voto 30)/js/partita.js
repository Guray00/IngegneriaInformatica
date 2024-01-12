function init(){
    let bottone = document.querySelector("input[type='submit']");
    if(bottone)
        bottone.addEventListener("click", invia);
}

function invia(e){
    let primoset1 = document.querySelector("input[name='primoset1']");
    let primoset2 = document.querySelector("input[name='primoset2']");
    let secondoset1 = document.querySelector("input[name='secondoset1']");
    let secondoset2 = document.querySelector("input[name='secondoset2']");
    let terzoset1 = document.querySelector("input[name='terzoset1']");
    let terzoset2 = document.querySelector("input[name='terzoset2']");
    if(!primoset1.validity.valid||primoset1.value===""||!primoset2.validity.valid||primoset2.value===""||!secondoset1.validity.valid||secondoset1.value===""||!secondoset2.validity.valid||secondoset2.value===""||!terzoset1.validity.valid||!terzoset2.validity.valid)
        e.preventDefault();
    
}