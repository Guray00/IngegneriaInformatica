export let justClosedForm = false;
export function resetJustClosedForm() {
  justClosedForm = false;
}

export function showForm(formToShow, formToHide) {
  document.getElementById(formToShow).classList.remove('hidden');
  document.getElementById(formToHide).classList.add('hidden');
}

document.getElementById('showLoginBtn').onclick =
document.getElementById('showLoginLink').onclick = function(e) {
  if (e) e.preventDefault();
  showForm('login-form', 'signup-form');
};

document.getElementById('showSignupBtn').onclick =
document.getElementById('showSignupLink').onclick = function(e) {
  if (e) e.preventDefault();
  showForm('signup-form', 'login-form');
};

['login-form', 'signup-form'].forEach(formId => {
  const formDiv = document.getElementById(formId);

  document.addEventListener('mousedown', function(e) {
    if (!formDiv.classList.contains('hidden') && !formDiv.contains(e.target)) {
      formDiv.classList.add('hidden');
      justClosedForm = true;

      formDiv.querySelectorAll('input').forEach(input => input.value = '');
      e.stopPropagation();
    }
  });

  document.addEventListener('keydown', function(e) {
    if (!formDiv.classList.contains('hidden') && e.key === 'Escape') {
      formDiv.classList.add('hidden');
      formDiv.querySelectorAll('input').forEach(input => input.value = '');
    }
  });
});