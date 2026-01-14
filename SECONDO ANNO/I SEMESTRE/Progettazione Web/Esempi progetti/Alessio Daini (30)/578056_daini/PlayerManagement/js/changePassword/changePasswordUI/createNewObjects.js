import { askCheckPasswordPacket } from "../changePasswordAPI/askCheckPasswordPacket.js"; 

// funzioni di utilità per createDiv di checkCorrectPassordUI.js:

export function createPassword(divToggle){
    const password = document.createElement("input");
    password.type = "password";
    password.placeholder = "nuovaPassword";
    password.title = "La password deve avere almeno 8 caratteri, con almeno un numero, una lettera dell'alfabeto inglese e un carattere speciale";
    password.pattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}$";
    password.required = true;
    password.name = "changePassword";
    divToggle.appendChild(password);

    return password;
}

export function createIToggle(password){
    const i = document.createElement("i");
    i.id = "togglePassword";
    i.classList.add("TogglePassword");
    
    i.addEventListener("click", () => {
        const isVisible = password.type === "text";
        password.type = isVisible ? "password" : "text";
        i.classList.toggle("visible", !isVisible);
      });

    return i;
}

export function createNewButton(username,password,form){
    const button2 = document.createElement("button");
    button2.textContent = "Cambia password";
    button2.type = "button";

    //listener che ascolta l'input, al cambiamento del suo contenuto, che resetta l'errore
    password.addEventListener("change", () => {
        password.setCustomValidity("");
    });

    //listener sul bottone
    button2.onclick = async function() {
        //se la password non è valida, riporto l'errore
        if (!password.checkValidity()) {
            form.reportValidity();
            return;
        }

        try {
            //mandata la richiesta, per verificare se la password può essere cambiata o no
            const ok = await askCheckPasswordPacket(username.value, password.value);

            // cambiata, modifico il tasto del bottone e attivo un listener per tornare indietro
            if (ok) {
                button2.textContent = "Vai a fare login";
                button2.onclick = () => {
                    window.location.replace("login.html");
                };
            } else {
                //altrimenti segno l'errore, indicando che la password è coincidente con quella attuale
                password.setCustomValidity("La password nuova è coincidente con quella attuale");
                form.reportValidity();
            }
        } catch (error) {
            console.error(error);
        }
    };

    return button2;
    
}