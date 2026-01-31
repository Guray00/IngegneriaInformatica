export async function requestRankingDBMS() {
    try {
        const res = await fetch("../php/ranking.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" }
        });
        const data = await res.json();
        if (data.success) {
            console.log("istruzione avvenuta con successo");
            return data.rows;
        } else {
            console.log("istruzione fallita");
            return [];
        }
    } catch (error) {
        console.error("Errore", error);
        return [];
    }
}
