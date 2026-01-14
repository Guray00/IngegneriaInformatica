export async function checkCorrectAnswer(username, answer) {
    //richiesta al metodo php corrente, mandando username e risposta, per poter modificare la password
    try {
        const res = await fetch("../../php/RecoverPassword/checkCorrectPassword.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, answer })
        });

        console.log("ricevuto informazioni con successo (checkCorrectAnswer)");
        //restituisco la risposta
        const data = await res.json();
        return data;
        //in caso si restituisce un messaggio di tipo false
    } catch (error) {
        console.error(error);
        return { success: false };
    }
}
