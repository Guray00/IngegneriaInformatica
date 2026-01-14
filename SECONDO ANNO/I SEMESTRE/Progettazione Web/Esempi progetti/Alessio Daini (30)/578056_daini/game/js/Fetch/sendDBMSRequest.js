import { showRecordDialog } from "../Draw/draw.js";
import{Config} from "../Configuration/Config.js";

export async function sendDBMSRequest(username) {
    
    try {
        const res = await fetch("../php/gameManagePoint.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: username, points: Config.points })
        });
        const data = await res.json();
        if (data.success) {
            console.log("istruzione avvenuta con successo");
            showRecordDialog(true);
        } else {
            console.log("istruzione fallita");
            showRecordDialog(false);
        }
    } catch (error) {
        console.error("Errore: ", error);
    }
}