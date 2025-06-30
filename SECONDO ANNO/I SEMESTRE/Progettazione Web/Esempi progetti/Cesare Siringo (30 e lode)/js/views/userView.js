import { GridCanvas } from "../render/gridCanvas.js";
import { Save } from "../lib/save.js";

export class UserView {
    constructor(apiContext, loadSaveCallback, signupForm, loginForm, userProfile, showLoginButton, showSignupButton) {
        this.apiContext = apiContext;
        this.loadSaveCallback = loadSaveCallback;
        this.signupForm = signupForm;
        this.loginForm = loginForm;
        this.userProfile = userProfile;

        // add form event listeners
        this.signupForm.addEventListener("submit", async (event) => {
            event.preventDefault();

            const formData = new FormData(this.signupForm);
            console.log(formData);

            const success = await this.apiContext.signup(formData);
            if(success) this.showProfile();
        });

        this.loginForm.addEventListener("submit", async (event) => {
            event.preventDefault();

            const formData = new FormData(this.loginForm);
            console.log(formData);

            const success = await this.apiContext.login(formData);
            if(success) this.showProfile();
        });

        // add button event listeners
        showLoginButton.addEventListener("click", () => {
            this.showLogin();
        });

        showSignupButton.addEventListener("click", () => {
            this.showSignup();
        });

        // Initialize view state
        this.showLogin();
    }

    createCard(id, save) {
        const card = document.createElement("div");
        card.className = "save-card";

        const canvas = document.createElement("canvas");
        canvas.width = 150;
        canvas.height = 150;
        const gridCanvas = new GridCanvas(save.grid, canvas, save.palette);
        gridCanvas.render();
        card.appendChild(canvas);

        const nameElement = document.createElement("div");
        nameElement.className = "save-name";
        nameElement.textContent = save.name;
        card.appendChild(nameElement);

        const loadButton = document.createElement("button");
        loadButton.textContent = "Load";
        loadButton.addEventListener("click", (event) => {
            event.preventDefault();
            console.log(`Loading save: ${save.name}`);
            this.loadSaveCallback(save);
        });
        card.appendChild(loadButton);

        const deleteButton = document.createElement("button");
        deleteButton.addEventListener("click", async (event) => {
            event.preventDefault();
            console.log(`Deleting save: ${save.name}`);

            // Confirm deletion
            if (confirm(`Are you sure you want to delete "${save.name}"? This action cannot be undone.`)) {
                const success = await this.apiContext.delete(id);
                if (success) {
                    // Refresh the profile view to show updated saves list
                    this.renderProfile();
                }
            }
        });
        deleteButton.textContent = "Delete";
        card.appendChild(deleteButton);

        return card;
    }

    renderProfile() {
        this.userProfile.innerHTML = ""; // Clear previous content

        const welcomeMessage = document.createElement("h2");
        welcomeMessage.textContent = `Welcome, ${this.apiContext.user.username}!`;
        this.userProfile.appendChild(welcomeMessage);

        const savesTitle = document.createElement("h3");
        savesTitle.textContent = "Your Saves:";
        this.userProfile.appendChild(savesTitle);

        const savesContainer = document.createElement("div");
        savesContainer.className = "saves-container";

        this.apiContext.user.saves.forEach((save) => {
            const card = this.createCard(save.save_id, Save.fromJSON(JSON.parse(save.data)));
            savesContainer.appendChild(card);
        });

        this.userProfile.appendChild(savesContainer);
    }

    showSignup() {
        this.signupForm.hidden = false;
        this.loginForm.hidden = true;
        this.userProfile.hidden = true;
    }

    showLogin() {
        this.signupForm.hidden = true;
        this.loginForm.hidden = false;
        this.userProfile.hidden = true;
    }

    showProfile() {
        this.renderProfile();
        this.signupForm.hidden = true;
        this.loginForm.hidden = true;
        this.userProfile.hidden = false;
    }
}