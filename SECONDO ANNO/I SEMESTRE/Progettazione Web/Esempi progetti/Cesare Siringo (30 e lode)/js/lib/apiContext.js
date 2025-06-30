export class ApiContext {
    constructor() {
        this.user = null;
        this.token = null;
        this.loggedIn = false;
    }

    async signup(formData) {
        try {
            const response = await fetch("./php/signup.php", {
                method: "POST",
                body: formData
            });
            const responseData = await response.json();

            if(responseData.status === "success") {
                this.user = responseData.user;
                this.token = responseData.token;
                this.loggedIn = true;
                return true;
            } else {
                alert(responseData.message);
                return false;
            }
        } catch (error) {
            console.error("Error during signup:", error);
            alert("An error occurred during signup. Please try again.");
            return false;
        }
    }

    async login(formData) {
        try {
            const response = await fetch("./php/login.php", {
                method: "POST",
                body: formData
            });
            const responseData = await response.json();

            if (responseData.status === "success") {
                this.user = responseData.user;
                this.token = responseData.token;
                this.loggedIn = true;
                console.log(this.user);
                return true;
            } else {
                alert(responseData.message);
                return false;
            }
        } catch (error) {
            console.error("Error during login:", error);
            alert("An error occurred during login. Please try again.");
            return false;
        }
    }

    async save(saveName, saveData) {
        if (!this.loggedIn) {
            alert("You must be logged in to save.");
            return false;
        }

        const requestData = {
            save_name: saveName,
            save_data: saveData,
            user_id: this.user.id,
            token: this.token
        };

        try {
            const response = await fetch("./php/save.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(requestData)
            });
            const responseData = await response.json();
            if (responseData.status !== "success") {
                alert(responseData.message);
                return responseData;
            }

            this.user.saves.push({
                user_id: this.user.id,
                save_id: responseData.save_id,
                name: saveName,
                data: saveData
            })

            console.log(this.user);

            return responseData;
        } catch (error) {
            console.error("Error during save:", error);
            alert("An error occurred while saving. Please try again.");
        }
    }

    async delete(saveId) {
        if (!this.loggedIn) {
            alert("You must be logged in to delete a save.");
            return false;
        }

        const requestData = {
            save_id: saveId,
            token: this.token
        };

        try {
            const response = await fetch("./php/delete.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(requestData)
            });

            const result = await response.json();

            if (result.status === "success") {
                // Remove the save from the user's saves
                this.user.saves = this.user.saves.filter((s) => s.save_id !== saveId);
                return true;
            } else {
                alert(result.message || "An error occurred while deleting the save.");
                return false;
            }
        } catch (error) {
            console.error("Error during delete:", error);
            alert("An error occurred while deleting the save. Please try again.");
            return false;
        }
    }
}