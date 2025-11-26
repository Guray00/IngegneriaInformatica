// js/student.js

/* ----- navigazione tab ----- */
$$('.sidebar nav a').forEach((a) => {
    a.addEventListener('click', (e) => {
        e.preventDefault();

        // attivazione tab selezionata
        $$('.sidebar nav a').forEach((x) => x.classList.remove('active'));
        a.classList.add('active');
        switchTab(a.dataset.tab);
    });
});

function switchTab(tab) {
    console.log('switchTab called', {tab});
    // nasconde tutte le tabpages e mostra solo quella selezionata 
    $$('.tabpage').forEach((p) => p.classList.add('hidden'));
    const target = '#tab-' + tab;
    $(target).classList.remove('hidden');
    const titles = {
        book: 'Prenota una lezione filtrando fra quelle disponibili',
        upcoming: 'Visualizza le prossime lezioni prenotate',
        history: 'Visualizza le lezioni passate e lo stato di pagamento',
        payments: 'Visualizza e gestisci i tuoi pagamenti',
    };
    $('#pageTitle').textContent = titles[tab];
}


/* ----- tab prenotazione ----- */
async function loadAvailableSlots(){
    // recupero container
    const container = $('#slotsList');
    container.innerHTML = 'Caricamento slot...';
    
    // recupero filtri
    const filterMode = $('#filterMode').value;
    const filterTutor = $('#filterTutor').value.trim().toLowerCase();

    // recupero dati
    const res = await fetch('../api/slots_available.php');
    const data = await res.json();
    if (!data.success){
        alert('Errore caricamento slots: ' + data.message);
        container.innerHTML = 'Errore nel caricamento degli slot';
        return;
    }

    console.log('API slots:', data.slots);
    console.log('filterMode=', filterMode, 'filterTutor=', filterTutor);

    // costruzione array con slot filtrati
    const filtered = [];
    for (let i = 0; i < data.slots.length; i++){
        const s = data.slots[i];
        if ((filterMode && filterMode !== '' && s.mode !== 'both' && filterMode !== s.mode) || (filterTutor && filterTutor !== '' && !String(s.tutor_name.toLowerCase()).includes(filterTutor)))
            continue;
        filtered.push(s);
    }

    // caso nessuno slot disponibile
    if (filtered.length === 0){
        container.innerHTML = 'Nessuno slot disponibile al momento';
        return;
    }

    // creazione slots
    container.innerHTML = '';
    for (let i = 0; i < filtered.length; i++){
        const s = filtered[i];
        
        // div dello slot
        const wrapper = document.createElement('div');
        wrapper.classList.add('slot');
        wrapper.dataset.slot_id = s.id;
        container.appendChild(wrapper);

        // header = tutor + data
        const head = document.createElement('div');
        head.classList.add('head');
        wrapper.appendChild(head);
        const strong = document.createElement('strong');
        strong.textContent = s.tutor_name;
        head.appendChild(strong);
        head.appendChild(document.createTextNode(displayDate(s.date) + ' ' + formatTime(s.time)));

        // info tutor
        const infoBtn = document.createElement('button');
        infoBtn.textContent = 'i';
        infoBtn.classList.add('btn-small', 'btn-info-icon');

        infoBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            showTutorInfo(s.tutor_id, s.tutor_name);
        });
        head.appendChild(infoBtn);

        // meta = modalità + prezzi
        const meta = document.createElement('div');
        meta.classList.add('meta');
        wrapper.appendChild(meta);
        let priceText = '';
        if (s.mode == 'both')
            priceText = 'online €' + s.cost_online  + ' / presenza €' + s.cost_presenza;
        else if (s.mode == 'online')
            priceText = 'online €' + s.cost_online;
        else priceText = 'presenza €' + s.cost_presenza;
        meta.textContent = priceText;

        // listener prenotazione
        wrapper.addEventListener('click', () => {
            window.bookingAttempt = {tutor_name: s.tutor_name, date: s.date, time: s.time, mode: s.mode, slot_id: s.id};
            openConfirm(s.tutor_name, s.date, s.time, s.mode, s.id);
        });
        console.log('added slot: ' + s.tutor_name + ', ' + s.date + ', ' + s.time + ', ' + s.mode + ', ' + priceText);
    }
}

$('#applyFilters').addEventListener('click', () => loadAvailableSlots());


/* ----- tabs lezioni future, passate e pagamenti ----- */
async function loadStats() {
    // recupero container
    const containerUpcoming = $('#upcomingList');
    containerUpcoming.innerHTML = 'Caricamento prenotazioni...';
    const containerHistory = $('#historyList');
    containerHistory.innerHTML = 'Caricamento storico...';
    const containerPayments = $('#paymentsList');
    containerHistory.innerHTML = 'Caricamento pagamenti...';

    // recupero dati
    const res = await fetch('../api/bookings_student.php');
    const data = await res.json();
    if (!data.success) {
        alert('Errore caricamento prenotazioni: ' + data.message);
        containerUpcoming.innerHTML = 'Errore nel caricamento delle prenotazioni';
        return;
    }

    // per ogni prenotazione aggiungo il campo done (passata o futura)
    data.bookings.forEach((s) => {
        s.done = (new Date(s.date + 'T' + s.time) < new Date());
        console.log(s);
    });

    // creazione slots per upcoming/history a seconda del campo 'done'
    containerUpcoming.innerHTML = '';
    containerHistory.innerHTML = '';
    containerPayments.innerHTML = '';
    let past = 0;
    let next = 0;
    let toPay = 0;
    for (let i = 0; i < data.bookings.length; i++) {
        const s = data.bookings[i];
        let container;
        if (s.done){
            container = containerHistory;
            past++;
        }
        else {
            container = containerUpcoming;
            next++;
        }

        // div dello slot
        const wrapper = document.createElement('div');
        wrapper.classList.add('slot');
        container.appendChild(wrapper);

        // header = tutor + data
        const head = document.createElement('div');
        head.classList.add('head');
        wrapper.appendChild(head);
        const strong = document.createElement('strong');
        strong.textContent = s.tutor_name;
        head.appendChild(strong);
        head.appendChild(document.createTextNode(displayDate(s.date) + ' ' + formatTime(s.time)));
        
        // meta = modalità + prezzi
        const meta = document.createElement('div');
        meta.classList.add('meta');
        wrapper.appendChild(meta);
        let mode, price;
        if (s.chosenMode == 0){
            mode = s.mode;
            price = (s.mode === 'online') ? s.cost_online : s.cost_presenza;
        }
        else if (s.chosenMode == 1){
            mode = 'online';
            price = s.cost_online;
        }
        else {
            mode = 'presenza';
            price = s.cost_presenza;
        }

        if (s.done && !s.paid)
            toPay += parseFloat(price);
        meta.textContent = 'Modalità: ' + mode + ' • Prezzo: ' + price;

        if (!s.done) {
            // bottone di cancellazione (solo per prenotazioni future)
            const btn = document.createElement('button');
            btn.classList.add('btn-small');
            btn.textContent = 'Cancella';
            btn.addEventListener('click', async () => {
                btn.disabled = true;

                if (!confirm('Sei sicuro di voler cancellare questa prenotazione?'))
                    return btn.disabled = false;

                // controllo data limite cancellazione (24h prima)
                const now = new Date();
                const bookingDate = new Date(s.date + 'T' + s.time);
                const diffMs = bookingDate - now;
                const diffHrs = diffMs / (1000 * 60 * 60);
                if (diffHrs < 24) {
                    alert('Impossibile cancellare: la prenotazione è entro le 24 ore.');
                    btn.disabled = false;
                    return;
                }

                const res = await fetch('../api/bookings_cancel.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ booking_id: s.booking_id })
                });
                
                const data = await res.json();
                if (!data.success) {
                    alert('Errore cancellazione: ' + data.message);
                    btn.disabled = false;
                    return;
                }

                alert('Prenotazione cancellata con successo!');
                await loadAvailableSlots();
                await loadStats();
            });
            wrapper.appendChild(btn);
        }
        else {
            // stato pagamento (solo per prenotazioni passate)
            const status = document.createElement('span');
            status.textContent = s.paid ? 'Pagato' : 'Non pagato';
            status.style.fontWeight = 'bold';
            status.style.color = s.paid ? 'green' : 'red';
            wrapper.appendChild(status);
        }
    }

    // creazione slots per payments
    if (toPay > 0) {
        // crea array con prenotazioni da pagare raggruppate per tutor
        const tutorGrouped = {};
        for (const s of data.bookings) {
            if (!s.done || s.paid)
                continue;
            if (!tutorGrouped[s.tutor_name])
                tutorGrouped[s.tutor_name] = [];
            tutorGrouped[s.tutor_name].push(s);
        }
        console.log('tutorGrouped:', tutorGrouped);

        // per ogni tutor crea uno slot
        for (const tutor in tutorGrouped) {
            const bookings = tutorGrouped[tutor];
            const wrapper = document.createElement('div');
            wrapper.classList.add('slot');
            containerPayments.appendChild(wrapper);

            // header = tutor
            const head = document.createElement('div');
            head.classList.add('head');
            wrapper.appendChild(head);
            const strong = document.createElement('strong');
            strong.textContent = tutor;
            head.appendChild(strong);

            // meta = lista pagamenti da fare
            const meta = document.createElement('div');
            meta.classList.add('meta');
            wrapper.appendChild(meta);
            let total = 0;
            const ul = document.createElement('ul');
            for (const s of bookings) {
                let mode, price;
                if (s.chosenMode == 0){
                    mode = s.mode;
                    price = (s.mode === 'online') ? s.cost_online : s.cost_presenza;
                }
                else if (s.chosenMode == 1){
                    mode = 'online';
                    price = s.cost_online;
                }
                else {
                    mode = 'presenza';
                    price = s.cost_presenza;
                }
                total += parseFloat(price);

                const li = document.createElement('li');
                li.textContent = displayDate(s.date) + ' ' + formatTime(s.time) + ' • ' + mode + ' • €' + price;
                ul.appendChild(li);
            }
            meta.appendChild(ul);
            const totalP = document.createElement('p');
            totalP.style.fontWeight = 'bold';
            totalP.textContent = 'Totale da pagare: €' + total.toFixed(2);
            meta.appendChild(totalP);
        }
    }

    // aggiornamento statistiche
    $('#statUpcoming').textContent = next;
    $('#statHours').textContent = past;
    $('#statDue').textContent = '€' + toPay;

    // messaggi in caso di container vuoti
    if (next === 0)
        containerUpcoming.innerHTML = 'Nessuna prenotazione futura';
    if (past === 0)
        containerHistory.innerHTML = 'Nessuna prenotazione passata';
    if (toPay === 0)
        containerHistory.innerHTML = 'Nessun pagamento in sospeso';
}


/* ----- gestione modal (sia prenotazione che info tutor) ----- */
const modal = $('#modal');
const modalBody = $('#modalBody');
const modalTitle = $('#modalTitle');
const confirmBtn = $('#modalConfirm');
const cancelBtn = $('#modalCancel');

function openConfirm(tutor, date, time, mode) {
    console.log('openConfirm called', { tutor, date, time, mode });

    // reset del modal a stato iniziale
    modalTitle.textContent = 'Conferma prenotazione';
    modalBody.innerHTML = '';
    confirmBtn.classList.remove('hidden-force'); // rimuove la classe che lo nascondeva
    confirmBtn.style.display = '';
    confirmBtn.disabled = true;
    cancelBtn.textContent = 'Annulla';
    cancelBtn.disabled = false;

    // creazione contenuto modal
    const info = document.createElement('p');
    modalBody.appendChild(info);

    const strong1 = document.createElement('strong');
    strong1.textContent = escapeHtml(tutor);

    const strong2 = document.createElement('strong');
    strong2.textContent = displayDate(date);

    const strong3 = document.createElement('strong');
    strong3.textContent = formatTime(time);

    info.appendChild(document.createTextNode('Stai per prenotare con '));
    info.appendChild(strong1);
    info.appendChild(document.createTextNode(' il '));
    info.appendChild(strong2);
    info.appendChild(document.createTextNode(' alle '));
    info.appendChild(strong3);
    info.appendChild(document.createTextNode('.'));

    if (mode === 'both') { // caso scelta modalità
        const modalDiv = document.createElement('div');
        modalBody.appendChild(modalDiv);

        const p = document.createElement('p');
        p.textContent = 'Seleziona la modalità:';
        modalDiv.appendChild(p);

        const modeChooser = document.createElement('div');
        modeChooser.className = 'mode-chooser';
        modalDiv.appendChild(modeChooser);

        const inputOn = document.createElement('input');
        inputOn.type = 'radio';
        inputOn.id = 'mOn';
        inputOn.name = 'chosenMode';
        inputOn.value = 'online';
        modeChooser.appendChild(inputOn);

        const labelOn = document.createElement('label');
        labelOn.htmlFor = 'mOn';
        labelOn.textContent = 'Online';
        modeChooser.appendChild(labelOn);

        const inputPre = document.createElement('input');
        inputPre.type = 'radio';
        inputPre.id = 'mPre';
        inputPre.name = 'chosenMode';
        inputPre.value = 'presenza';
        modeChooser.appendChild(inputPre);

        const labelPre = document.createElement('label');
        labelPre.htmlFor = 'mPre';
        labelPre.textContent = 'In presenza';
        modeChooser.appendChild(labelPre);

        // Listener per abilitare conferma solo dopo scelta
        const radios = modalBody.querySelectorAll('input[name="chosenMode"]');
        radios.forEach(r => {
            r.addEventListener('change', () => confirmBtn.disabled = false);
        });
    }
    else { // caso modalità singola
        const strongMode = document.createElement('strong');
        strongMode.textContent = escapeHtml(mode);
        modalBody.appendChild(document.createTextNode('Modalità: '));
        modalBody.appendChild(strongMode);
        confirmBtn.disabled = false; // abilita subito conferma
    }
    modal.classList.remove('hidden');
}

async function showTutorInfo(tutorId, tutorName) {
    console.log('showTutorInfo called', { tutorId, tutorName });

    // inizializzazione modal
    modalTitle.textContent = 'Profilo Tutor: ' + tutorName;
    modalBody.innerHTML = 'Caricamento profilo...';

    // nascondo bottone di conferma prenotazione
    confirmBtn.classList.add('hidden-force');
    cancelBtn.textContent = 'Chiudi';
    modal.classList.remove('hidden');

    // recupero dati
    const res = await fetch('../api/tutor_details.php?id=' + tutorId);
    const data = await res.json();
    if (!data.success) {
        modalBody.innerHTML = '<p class="error">' + data.message + '</p>';
        return;
    }

    const t = data.tutor;
    const subs = data.subjects;
    
    // modalBody = descrizione + materie + tariffe
    modalBody.innerHTML = '';

    // descrizione
    const descDiv = document.createElement('div');
    descDiv.className = 'tutor-detail-section';
    modalBody.appendChild(descDiv);
    
    const strong = document.createElement('strong');
    strong.textContent = 'Chi sono:';
    descDiv.appendChild(strong);
    
    const p = document.createElement('p');
    p.className = 'tutor-desc';
    p.textContent = t.description || 'Nessuna descrizione.';
    descDiv.appendChild(p);

    // materie
    const subDiv = document.createElement('div');
    subDiv.className = 'tutor-detail-section';
    modalBody.appendChild(subDiv);
    
    const subStrong = document.createElement('strong');
    subStrong.textContent = 'Materie insegnate:';
    subDiv.appendChild(subStrong);

    const tagsContainer = document.createElement('div');
    tagsContainer.className = 'tutor-tags';
    subDiv.appendChild(tagsContainer);

    if (subs.length > 0) { // popolazione materie insegnate
        subs.forEach(function (materia) {
            const span = document.createElement('span');
            span.className = 'badge info';
            span.textContent = materia;
            tagsContainer.appendChild(span);
        });
    }
    else {
        const span = document.createElement('span');
        span.textContent = 'Nessuna materia.';
        tagsContainer.appendChild(span);
    }

    // tariffe
    const ratesSection = document.createElement('div');
    ratesSection.className = 'tutor-detail-section';
    modalBody.appendChild(ratesSection);
    
    const strongRates = document.createElement('strong');
    strongRates.textContent = 'Tariffe:';
    ratesSection.appendChild(strongRates);
    
    const ul = document.createElement('ul');
    ul.className = 'tutor-rates';
    ratesSection.appendChild(ul);
    
    const liOnline = document.createElement('li');
    liOnline.textContent = 'Online: €' + t.cost_online;
    ul.appendChild(liOnline);
    
    const liPresenza = document.createElement('li');
    liPresenza.textContent = 'In presenza: €' + t.cost_presenza;
    ul.appendChild(liPresenza);
}

// handler bottoni
cancelBtn.addEventListener('click', () => modal.classList.add('hidden'));
confirmBtn.addEventListener('click', async () => {
    // disabilita bottone per evitare doppio click
    confirmBtn.disabled = true;

    // recupera modalità scelta
    let chosenMode = 0;
    if (window.bookingAttempt['mode'] === 'both') {
        const radios = $$('input[name="chosenMode"]');
        chosenMode = radios[0].checked ? 1 : 2;
    }

    // POST alla API di prenotazione
    const res = await fetch('../api/bookings_create.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ slot_id: window.bookingAttempt['slot_id'], mode: chosenMode })
    });
    const data = await res.json();

    // fallimento
    if (!data.success) {
        alert('Errore prenotazione: ' + data.message);
        confirmBtn.disabled = false;
        cancelBtn.textContent = 'Chiudi';
        return;
    }

    // successo
    modal.classList.add('hidden');
    alert('Prenotazione effettuata con successo!');
    await loadAvailableSlots();
    await loadStats();
});


/* ----- logout ----- */
$('#logoutBtn').addEventListener('click', async () => {
    await fetch("../api/logout.php");
    window.location.href = '../index.html';
});


/* ----- inizializzazione ----- */
async function init() {
    // recupero dati sessione e check
    const res = await fetch('../api/session.php');
    const data = await res.json();
    if (!data.logged || data.role !== 'student') { // non loggato come studente, redirect alla login
        window.location.href = '../index.html';
        return;
    }
    $('#studentName').textContent = 'Ciao, ' + data.username;

    // caricamento vari pannelli
    await loadAvailableSlots();
    await loadStats();
}
init();