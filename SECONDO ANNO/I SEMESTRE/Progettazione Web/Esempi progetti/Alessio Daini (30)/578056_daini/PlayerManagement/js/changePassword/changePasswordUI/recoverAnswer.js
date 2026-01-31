import { recoverQuestion } from "../changePasswordAPI/recoverQuestion.js";

// recupero domanda specifico per l'utente
export async function recoverQuestionAnswer(username,question) {
    try {
        //recupero la domanda
        const data = await recoverQuestion(username.value);
        //bottone dinamico
        const button2 = document.getElementById("sendQuestion");

        //se c'è stato un fulfillment, disabilito il bottone e aggiorno il testo, scrivendo la domanda
        if (data.success) {
            question.textContent = "Domanda: " + data.question;
            button2.disabled = false;
        //altrimenti, si ritorna al formato originale
        } else {
            question.textContent = "Domanda:";
            button2.disabled = true;
        }
    //segnalazione errori
    } catch (error) {
        console.error(error);
    }
}