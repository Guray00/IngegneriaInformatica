import{checkCorrectCredentials} from "./correctFormat.js";
import{goBack,subscribe,goToChangePassword} from "./changePageLogin.js";

const username = document.getElementById("usernameInput");
const password = document.getElementById("passwordInput");
const form = document.querySelector("form");
const toggle = document.querySelector(".TogglePassword");

document.getElementById("loginBtn").addEventListener("click", () =>{
  checkCorrectCredentials(form,username,password)});

document.getElementById("backBtn").addEventListener("click", () =>{
  goBack()
});

document.getElementById("signupLink").addEventListener("click", (event) =>{
  subscribe(event);
});

document.getElementById("recoverLink").addEventListener("click", (event) =>{
  goToChangePassword(event);
});

password.addEventListener("input", () => {
  password.setCustomValidity("");
});

toggle.addEventListener("click", () => {
  const isVisible = password.type === "text";
  password.type = isVisible ? "password" : "text";
  toggle.classList.toggle("visible", !isVisible);
});
