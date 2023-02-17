function setUp() {

    //Corretta visualizzazione degli elementi
    document.getElementById('intManual').textContent = 'Quick Manual';
    document.getElementById('intRanking').textContent = 'Ranking';
    document.getElementById('manual').style.display = 'none';
    document.getElementById('ranking').style.display = 'none';
}

function showManual() {
    //Check sulla visibilità del manuale
    if (document.getElementById('manual').style.display == 'flex') {
        document.getElementById('intManual').textContent = 'Quick Manual';
        document.getElementById('manual').style.display = 'none';
        document.getElementById('intManual').style.backgroundColor = 'rgb(65, 105, 225)';

    } else {
        document.getElementById('intManual').textContent = 'Close Quick Manual';
        document.getElementById('manual').style.display = 'flex';
        document.getElementById('intRanking').textContent = 'Ranking';
        document.getElementById('ranking').style.display = 'none';
        document.getElementById('intManual').style.backgroundColor = 'blue';
        document.getElementById('intRanking').style.backgroundColor = 'rgb(65, 105, 225)';
    }
}

function showRanking() {
    //Check sulla visibilità della classifica
    if (document.getElementById('ranking').style.display == 'flex') {
        document.getElementById('intRanking').textContent = 'Ranking';
        document.getElementById('ranking').style.display = 'none';
        document.getElementById('intRanking').style.backgroundColor = 'rgb(65, 105, 225)';
    } else {
        document.getElementById('intRanking').textContent = 'Close Ranking';
        document.getElementById('ranking').style.display = 'flex';
        document.getElementById('intManual').textContent = 'Quick Manual';
        document.getElementById('manual').style.display = 'none';
        document.getElementById('intRanking').style.backgroundColor = 'blue';
        document.getElementById('intManual').style.backgroundColor = 'rgb(65, 105, 225)';
    }
}