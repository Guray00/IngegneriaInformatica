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