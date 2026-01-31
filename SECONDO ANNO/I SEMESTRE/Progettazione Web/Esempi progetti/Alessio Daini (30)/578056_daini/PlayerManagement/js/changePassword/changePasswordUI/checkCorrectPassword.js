import { checkCorrectAnswer } from "../changePasswordAPI/checkCorrectAnswer.js";
import { createChangePasswordUI } from "./checkCorrectPasswordUI.js";
//funzione per modificare la password
export async function checkCorrectPassword(username,answer,form,button) {
    
    //pulisco l'errore
    answer.setCustomValidity("");

    //in caso di errore l'errore deve essere riportato
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    try {
        //fetch per verificare se la risposta mandato dall'utente è corretta o no
        const data = await checkCorrectAnswer(username.value, answer.value);
        //fulfillment: cambio la password e modifico il bottone
        if (data.success) {
            createChangePasswordUI(form,username,button);
        } else {
            //in caso di errore aggiorno l'errore e specifico il messaggio
            answer.setCustomValidity("risposta sbagliata");
            form.reportValidity();
        }

    } catch (error) {
        console.error(error);
    }
}