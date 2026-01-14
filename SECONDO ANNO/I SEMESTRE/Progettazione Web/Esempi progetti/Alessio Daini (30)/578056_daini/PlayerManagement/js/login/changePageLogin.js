export function goBack(){
    window.location.replace("../Introduction/firstPage.html");
  }
  
export function subscribe(event) {
    event.preventDefault();                // blocca il comportamento predefinito del link
    window.location.replace("../userServices/signUp.html"); // sostituisce la pagina corrente
  }
  
export function goToChangePassword(event) {
    event.preventDefault();                
    window.location.replace("../userServices/changePassword.html");
  }