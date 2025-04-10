class AuthContext {
  constructor() {
    this.user = null;
    this.token = null;
    this.loggedIn = false;
  }

  async handleSignup(event) {
    event.preventDefault();

    const usernameInput = document.getElementById("signup-username");
    const emailInput = document.getElementById("signup-email");
    const passwordInput = document.getElementById("signup-password");

    if (!usernameInput.checkValidity()) {
      alert(
        "The username must be at least 3 characters long and at most 30 characters long.\nAllowed symbols: ! # $ % & * ^ _ - ~",
      );
      return;
    }

    if (!emailInput.checkValidity()) {
      alert("Please enter a valid email address.");
      return;
    }

    if (!passwordInput.checkValidity()) {
      alert(
        "The password must be at least 6 characters long and at most 30 characters long.\nAllowed symbols: ! # $ % & * ^ _ - ~",
      );
      return;
    }

    const username = usernameInput.value;
    const email = emailInput.value;
    const password = passwordInput.value;

    const { user, token, loggedIn } = await apiContext.signup(
      username,
      email,
      password,
    );

    this.user = user;
    this.token = token;
    this.loggedIn = loggedIn;

    if (loggedIn) {
      userDashboard.displayUserProfile();
    }
  }

  async handleLogin(event) {
    event.preventDefault();

    const usernameInput = document.getElementById("login-username");
    const passwordInput = document.getElementById("login-password");

    const username = usernameInput.value;
    const password = passwordInput.value;

    const data = new FormData();
    data.append("username", username);
    data.append("password", password);

    const res = await apiContext.login(username, password);

    const { user, token, loggedIn } = res;

    this.user = user;
    this.token = token;
    this.loggedIn = loggedIn;

    if (loggedIn) {
      userDashboard.displayUserProfile();
    }
  }
}
