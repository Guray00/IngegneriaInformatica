//richiesta del pacchetto della password
export async function askCheckPasswordPacket(username, passwordString) {
    //fase di fetch: richiesta tramite metodo post, inviando username e password nel pacchetto
    try {
        const res = await fetch("../../php/RecoverPassword/changePasswordTrue.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password: passwordString })
        });

        console.log("ricevuto informazioni con successo (askCheckPasswordPacket)");
    //restituisco la risposta
        const data = await res.json();
        return data.success;
    } catch (error) {
        console.error(error);
        return false;
    }
}