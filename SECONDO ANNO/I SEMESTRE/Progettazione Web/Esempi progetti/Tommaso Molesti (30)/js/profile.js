function toggleMenu() {
    var menu = document.getElementById('profile-menu');
    menu.classList.toggle('hidden');
}

// Se clicco su qualsiasi altro punto dello schermo si chiude il toggle
window.onclick = function(event) {
    var menu = document.getElementById('profile-menu');
    var profileIcon = document.getElementById('profile-icon');
    if (!profileIcon.contains(event.target)) {
        menu.classList.add('hidden');
    }
}