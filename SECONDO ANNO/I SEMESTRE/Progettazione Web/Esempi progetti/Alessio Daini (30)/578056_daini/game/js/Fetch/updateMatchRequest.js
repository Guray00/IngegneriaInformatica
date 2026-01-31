import{Config} from "../Configuration/Config.js";

export async function updateMatchRequest(username, date, won) {
    
    try {
        const res = await fetch("../php/match.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: username, points: Config.points, date: date, won: won })
        });
        const data = await res.json();
        console.log(data.message);
    } catch (error) {
        console.error("Errore", error);
    }
}