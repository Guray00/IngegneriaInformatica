function checkWrongFormat(form) {
    // forza la validazione nativa del browser
    if (!form.checkValidity()) {
      form.reportValidity(); // mostra i messaggi di errore nativi
      return true; // blocca il resto se non valido
    }
    return false;
  }


export async function checkCorrectCredentials(form,username,password) {
    const wrongFormat = checkWrongFormat(form);
    if (wrongFormat) return;
  
    try {
      const res = await fetch("../../php/Login/login.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: username.value,
          password: password.value
        })
      });
  
      const data = await res.json();
  
      if (data.success) {
        window.location.replace("../../../game/html/game.html");
      } else {
        password.setCustomValidity("credenziali errate");
        form.reportValidity();
      }
    } catch (error) {
      console.error("Error:", error);
    }
  }
  