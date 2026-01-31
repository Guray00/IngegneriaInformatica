import{Config} from "../Configuration/Config.js";

// funzione per leggere il cookie contenente lo username dell'utente
export async function readUsername() {
    
    try {
        const res = await fetch("../php/gameReadCookie.php", {
            method: "POST"
        });
        const data = await res.json();
        if (data.success) {
            console.log("ricevuto username con successo");
            const username = data.username;
            Config.username = username;
            return username;
        } else {
            console.log("nessun username trovato");
            return null;
        }
    } catch (error) {
        console.error("errore", error);
        return null;
    }
}