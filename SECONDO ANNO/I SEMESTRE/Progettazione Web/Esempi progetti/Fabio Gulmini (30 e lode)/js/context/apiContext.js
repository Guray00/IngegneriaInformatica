class ApiContext {
  constructor() {}

  async saveBoard(boardName, repr) {
    try {
      const response = await fetch("../php/save.php", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user_id: authContext.user.user_id,
          board: repr,
          name: boardName,
        }),
      });
      const data = await response.json();
      alert("Board saved successfully!");
      return data;
    } catch (error) {
      console.error(error);
      alert("An error occurred while saving the board.");
    }
  }

  async deleteBoard(boardId) {
    try {
      const response = await fetch("../php/delete.php", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user_id: authContext.user.user_id,
          board_id: boardId,
        }),
      });
      const data = await response.json();
    } catch (error) {
      console.error(error);
      alert("An error occurred while deleting the board.");
    }
  }

  async signup(username, email, password) {
    const formData = new FormData();
    formData.append("username", username);
    formData.append("email", email);
    formData.append("password", password);

    try {
      const response = await fetch("../php/signup.php", {
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
}
