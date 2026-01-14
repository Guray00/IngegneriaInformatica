export async function requestHistory(username) {
    console.log(username);
    try {
        const res = await fetch("../php/history.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: username })
        });
        const data = await res.json();
        if (data.success) {
            console.log("istruzione avvenuta con successo");
            return data.history;
        } else {
            console.log("istruzione fallita");
            return [];
        }
        
    } catch (error) {
        console.error("Errore: ", error);
        return [];
    }
}