export class ApiContext {
  constructor() {}


  async signup(username, email, password) {
    const formData = new FormData();
    formData.append("username", username);
    formData.append("email", email);
    formData.append("password", password);

    try {
      const response = await fetch("../php/register.php", {
        method: "POST",
        body: formData,
      });
      const responseData = await response.json();
      if (responseData.status === "success") {
        return {
          user: responseData.user,
          token: responseData.token,
          loggedIn: true,
        };
      } else {
        alert(responseData.message);
        return {
          user: null,
          token: null,
          loggedIn: false,
        };
      }
    } catch (error) {
      console.error("Error:", error);
      alert("An error occurred. Please try again.");
      return {
        user: null,
        token: null,
        loggedIn: false,
      };
    }
  }

  async login(username, password) {
    const data = new FormData();
    data.append("username", username);
    data.append("password", password);

    try {
      const response = await fetch("../php/login.php", {
        method: "POST",
        body: data,
      });
      const responseData = await response.json();
      if (responseData.status === "success") {
        return {
          user: responseData.user,
          token: responseData.token,
          loggedIn: true,
        };
      } else {
        alert(responseData.message);
        return {
          user: null,
          token: null,
          loggedIn: false,
        };
      }
    } catch (error) {
      console.error("Error:", error);
      alert("An error occurred. Please try again.");
      return {
        user: null,
        token: null,
        loggedIn: false,
      };
    }
  }

  async saveGraph(graph) {
    const response = await fetch("../php/save.php", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(graph)
    });
    return await response.json();
  }

  async getGraphs() {
    const response = await fetch("../php/get_graphs.php");
    return await response.json();
  }
}
