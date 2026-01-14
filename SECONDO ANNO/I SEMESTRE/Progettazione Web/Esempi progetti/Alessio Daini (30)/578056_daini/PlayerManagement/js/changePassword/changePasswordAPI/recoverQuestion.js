export async function recoverQuestion(username) {
    //fetch sul file php per recuperare la domanda, inserendo nel paccheto lo username, attraverso il metodo POST
    try {
        const res = await fetch("../../php/RecoverPassword/recoverQuestion.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username })
        });

        console.log("ricevuto informazioni con successo (recoverQuestion)");
        //ricevo la risposta in formato json
        const data = await res.json();
        //dato restituito alla funzione chiamante
        return data;
    } catch (error) {
        console.error(error);
        return { success: false };
    }
}