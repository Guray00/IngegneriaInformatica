var ErrorLogin = [];
var ErrorRegister = [];

function Accedi(){
    document.querySelector("#error-login").style.visibility = "hidden";
    let user = document.querySelector("#username-login");
    let psw = document.querySelector("#password-login");
    user.style.border = "2px solid black";
    psw.style.border = "2px solid black";
    if(user.value == "") LampeggiaBordoRosso(user);
    if(psw.value == "") LampeggiaBordoRosso(psw);
    if(user.value == "" || psw.value == "") return;
    
    var x = new XMLHttpRequest();
    var url = "./ajax/ajax-response.php";
    var vars = "id=1&username="+user.value+"&password="+psw.value;
    x.open("POST", url, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.onreadystatechange = function() {
      if(x.readyState == 4 && x.status == 200) {
          var data = x.responseText;
          if(data == "CredenzialiErrate"){
              user.style.border = "2px solid red";
              psw.style.border = "2px solid red";
              document.querySelector("#error").style.visibility = "visible";
              return;
          } else location.href = "./personal-page.php";
      }
    }
    x.send(vars);
}

function LampeggiaBordoRosso(target){
    target.style.border = "2px solid red";
    setTimeout(function(){
        target.style.border = "2px solid black";
    }, 300);
}

function Registrati(){
  ErrorRegister = [];
  let azienda = document.querySelector("#azienda").value;
  let username = document.querySelector("#username-register").value;
  let psw1 = document.querySelector("#password-register").value;
  let psw2 = document.querySelector("#confirm-password-register").value;
  if(azienda == "") ErrorRegister.push("Nome agenzia obbligatorio.");
  if(username == "") ErrorRegister.push("Username obbligatorio.");
  if(psw1 != psw2) ErrorRegister.push("Le password non coincidono.");
  CorrectPassword(psw1);

  if(ErrorRegister.length == 0){
    // Controlla se l'username è già stato utilizzato all'interno del sito, se è nuovo, allora registra l'utente
    var x = new XMLHttpRequest();
    var url = "./ajax/ajax-response.php";
    var vars = "id=10&username="+username+"&agenzia="+azienda+"&psw="+psw1;
    x.open("POST", url, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.onreadystatechange = function() {
      if(x.readyState == 4 && x.status == 200) {
          var data = x.responseText;
          console.log(data);
          if(data == "NO" && username != "") {
            ErrorRegister.push("Username gi&agrave; scelto.");
          } else {
            document.querySelector("#error-register").style.visibility = "hidden";
            SetAccedi();
          }
      }
    }
    x.send(vars);
  } else MostraErrori();
}

function MostraErrori(){
  let error_register = "";
  for(let i=0; i<ErrorRegister.length; i++){
      error_register += "- "+ErrorRegister[i]+"<br>";
  }
  document.querySelector("#error-register").innerHTML = error_register;
  document.querySelector("#error-register").style.visibility = "visible";
}

function CorrectPassword(psw){
  let all = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*()=ç°§-]).{8,}$/;
  if(all.test(psw)) return true;
  let maiusc = /^(?=.*?[A-Z])/;
  if(!maiusc.test(psw)) ErrorRegister.push("Almeno una lettera maiuscola nella password.");
  let minusc = /^(?=.*?[a-z])/;
  if(!minusc.test(psw)) ErrorRegister.push("Almeno una lettera minuscola nella password.");
  let special = /^(?=.*?[#?!@$%^&*()=ç°§-])/;
  if(!special.test(psw)) ErrorRegister.push("Almeno un carattere speciale nella password: ?=.*?[#?!@$%^&*()=ç°§-]");
  let lungh = psw.length;
  if(lungh < 8) ErrorRegister.push("Almeno una 8 caratteri nella password.");
  return false;
}

function SetRegistrati(){
  document.querySelector("#login").style.display = "none";
  document.querySelector("#registrazione").style.display = "block";
}

function SetAccedi(){
 document.querySelector("#registrazione").style.display = "none";
 document.querySelector("#login").style.display = "block";
}

function MostraNascondiPsw(target, id){
  let ClassName = target.className;
  if(ClassName == "bi bi-eye")  {
    // Mostra la password
    document.querySelector("#"+id).setAttribute("type", "text");
    target.className = "bi bi-eye-slash";
  } else if (ClassName == "bi bi-eye-slash") {
    // Nascondi la password
    document.querySelector("#"+id).setAttribute("type", "password");
    target.className = "bi bi-eye";
  }
}
