export function displayUserProfile() {
  document.getElementById("user-info").classList.remove("hidden");
  document.getElementById("user-username").textContent = authContext.user.username;
  
  document.getElementById("showLoginBtn").classList.add("hidden");
  document.getElementById("showSignupBtn").classList.add("hidden");
}

export function hideUserProfile() {
  document.getElementById("user-info").classList.add("hidden");
  document.getElementById("user-username").textContent = "";
  
  document.getElementById("showLoginBtn").classList.remove("hidden");
  document.getElementById("showSignupBtn").classList.remove("hidden");
}