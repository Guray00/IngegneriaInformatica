import { Config } from "./Config.js"

// metodo per modificare la password dell'utente, tramite fetch
export async function sendRequestCorrectInsert() {
  
  try {
        const res = await fetch("../../php/SignUp/signUp.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: Config.username.value,
          password: Config.inputPassword1.value,
          question: Config.question.value,
          answer: Config.answer.value
        })
      });
  
      const data = await res.json();

      if (data.success === true) {
        console.log(data.success,data.message);
        Config.button.textContent = "Vai a fare il login";
        Config.historyButton.disabled = true;
          
        Config.button.onclick = () => {
            window.location.replace("../userServices/login.html");
          };

        return "found";
      }else{
        return data.message;
      }
  
    }catch (error) {
      console.error("Error:", error);
      return false;
    }
  }
  