let originalName;

function inizializza() {
    const nameInput = document.getElementById("change-name-input");
    const btn = document.getElementById("change-name-btn");
    originalName = nameInput.value;

    btn.disabled = true;

    nameInput.addEventListener("input", nameChange);
}

function nameChange() {
    const btn = document.getElementById("change-name-btn");
    const nameInput = document.getElementById("change-name-input");
    if (nameInput.value !== originalName) {
        btn.disabled = false;
    } else {
        btn.disabled = true;
    }
}

function handleMessage(event) {
    const confirmed = confirm('Sei sicuro di voler terminare la festa?');
    
    if (!confirmed) {
        event.preventDefault();
    }
}