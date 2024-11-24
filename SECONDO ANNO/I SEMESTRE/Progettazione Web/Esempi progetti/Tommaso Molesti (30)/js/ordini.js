function inizializza() {
    const checkboxes = document.querySelectorAll('.order-checkbox');
    const submitBtn = document.getElementById('submit-btn');

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const atLeastOneChecked = Array.from(checkboxes).some(cb => cb.checked);
            
            submitBtn.disabled = !atLeastOneChecked;
        });
    });
}

function confirmDelete(event) {
    const confirmation = confirm("Sei sicuro di voler eliminare questo ordine?");
    if (!confirmation) {
        event.preventDefault();
        return false;
    }
    return true;
}


