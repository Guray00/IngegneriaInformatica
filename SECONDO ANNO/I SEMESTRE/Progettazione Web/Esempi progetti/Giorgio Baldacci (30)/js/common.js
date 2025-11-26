// common.js

// helper per query DOM
const $ = (target) => document.querySelector(target);
const $$ = (target) => Array.from(document.querySelectorAll(target));

// funzione per eseguire escaping di stringhe HTML
function escapeHtml(str) {
    if (str === null || str === undefined)
        return '';
    return String(str).replace(/[&<>"']/g, function (m) {
        return ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        }[m]);
    });
}

// formattazione date e orari
function displayDate(d) {
    if (!d)
        return '';
    const date = new Date(d);
    return date.toLocaleDateString('it-IT', { year: '2-digit', month: '2-digit', day: '2-digit' });
}

function formatTime(t) {
    if (!t)
        return '';
    return t.length >= 5 ? t.slice(0, 5) : t;
}