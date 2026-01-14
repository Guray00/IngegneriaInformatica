import { Config } from "./Config.js";

//-------------------------------------LISTENERS PER L'IMMAGINE DENTRO L'INPUT PER LE PASSWORD-----------------------------

export function toggleEvent(){
    
Config.toggle1.addEventListener("click", () => {
    const isVisible = Config.inputPassword1.type === "text";
    Config.inputPassword1.type = isVisible ? "password" : "text";
    Config.toggle1.classList.toggle("visible", !isVisible);
  });
  
  Config.toggle2.addEventListener("click", () => {
    const isVisible = Config.inputPassword2.type === "text";
    Config.inputPassword2.type = isVisible ? "password" : "text";
    Config.toggle2.classList.toggle("visible", !isVisible);
  });

}
