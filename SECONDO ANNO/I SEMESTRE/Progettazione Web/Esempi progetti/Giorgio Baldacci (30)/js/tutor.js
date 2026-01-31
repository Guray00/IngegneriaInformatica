// js/tutor.js

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
    console.log('switchTab called', { tab });
    // nasconde tutte le tabpages e mostra solo quella selezionata 
    $$('.tabpage').forEach((p) => p.classList.add('hidden'));
    const target = '#tab-' + tab;
    $(target).classList.remove('hidden');
    
    const titles = {
        slots: 'Crea una lezione o visualizza quelle disponibili',
        history: 'Visualizza lezioni passate e lo stato di pagamento',
        upcoming: 'Visualizza le prossime lezioni prenotate',
        payments: 'Gestisci i tuoi pagamenti',
        config: 'Configura il tuo account tutor'
    };
    $('#pageTitle').textContent = titles[tab];

    // caricamento dinamico dati se necessario
    if (tab === 'slots') loadCreatedSlots();
    if (tab === 'history' || tab === 'upcoming' || tab === 'payments') loadStats();
    if (tab === 'config') loadConfig();
}


/* ----- tab slot e gestione modal ----- */
const modal = $('#modal');
const modalSlotDate = $('#slotDate');
const modalSlotTime = $('#slotTime');
const modalSlotMode = $('#slotMode');
const confirmBtn = $('#modalConfirm');
const cancelBtn = $('#modalCancel');

$('#createSlotBtn').addEventListener('click', (e) => {
    e.preventDefault();
    console.log('createSlotBtn clicked');

    // formattazione iniziale del form
    $('#modalTitle').textContent = 'Crea nuovo slot';
    $('#createSlotForm').classList.remove('hidden');
    modalSlotDate.value = '';
    modalSlotTime.value = '';
    confirmBtn.disabled = false;
    cancelBtn.disabled = false;

    // mostra modal
    modal.classList.remove('hidden');
});

cancelBtn.addEventListener('click', () => {
    modal.classList.add('hidden');
    $('#createSlotForm').classList.add('hidden');
});
confirmBtn.addEventListener('click', async () => {
    // disabilita bottone per evitare doppio click
    console.log('confirmBtn clicked');
    confirmBtn.disabled = true;

    // recupero dati
    let date = modalSlotDate.value;
    let time = modalSlotTime.value;
    let mode = modalSlotMode.value;
    console.log("Creazione slot, " + date + " " + time + " " + mode);
    
    // controllo dati
    if (!date || !time || !mode || new Date(date + 'T' + time) < new Date()) {
        alert('Errore: dati form non validi');
        confirmBtn.disabled = false;
        return;
    }

    // creazione slot
    const res = await fetch('../api/slots_create.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({date: date, time: time, mode: mode})
    });
    const data = await res.json();

    // fallimento
    if (!data.success) {
        alert('Errore creazione nuovo slot: ' + data.message);
        confirmBtn.disabled = false;
        return;
    }

    // successo
    modal.classList.add('hidden');
    $('#createSlotForm').classList.add('hidden');
    alert('Slot creato con successo!');
    await loadCreatedSlots();
});

async function loadCreatedSlots() {
    console.log('loadCreatedSlots called');
    // recupero container
    const container = $('#slotsList');
    container.innerHTML = 'Caricamento slot...';

    // recupero dati
    const res = await fetch('../api/slots_available.php');
    const data = await res.json();
    if (!data.success) {
        alert('Errore caricamento slots: ' + data.message);
        container.innerHTML = 'Errore nel caricamento degli slot';
        return;
    }

    // filtraggio slot creati dal tutor loggato
    let slots_available = [];
    const sessionRes = await fetch('../api/session.php');
    const sessionData = await sessionRes.json();
    for (const s of data.slots)
        if (s.tutor_id === sessionData.user_id)
            slots_available.push(s);
    console.log({ slots_available });
    if (slots_available.length === 0) {
        container.innerHTML = 'Non hai ancora creato nessuno slot.';
        return;
    }
    
    // creazione slots
    container.innerHTML = '';
    for (let i = 0; i < slots_available.length; i++) {
        const s = slots_available[i];

        // div dello slot
        const wrapper = document.createElement('div');
        wrapper.classList.add('slot');
        wrapper.dataset.slot_id = s.id;
        container.appendChild(wrapper);

        // header = data
        const head = document.createElement('div');
        head.classList.add('head');
        wrapper.appendChild(head);
        const strong = document.createElement('strong');
        strong.textContent = displayDate(s.date) + ' ' + formatTime(s.time);
        head.appendChild(strong);

        // meta = modalità
        const meta = document.createElement('div');
        meta.classList.add('meta');
        let textMode = '';
        if (s.mode === 'both')
            textMode = 'In presenza o online';
        else textMode = s.mode;
        meta.textContent = textMode;
        wrapper.appendChild(meta);

        // delete button
        const btn = document.createElement('button');
        btn.classList.add('btn-small');
        btn.textContent = 'Cancella';
        btn.addEventListener('click', async () => {
            btn.disabled = true;
            const res = await fetch('../api/slots_cancel.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ slot_id: s.id })
            });
            const data = await res.json();

            if (!data.success) {
                alert('Errore cancellazione slot: ' + data.message);
                btn.disabled = false;
                return;
            }

            alert('Slot cancellato con successo!');
            await loadCreatedSlots();
        });
        wrapper.appendChild(btn);
    }
}


/* ----- statistiche per varie tabs ----- */
async function loadStats() {
    console.log('loadStats called');
    // recupero containers
    const containerHistory = $('#historyList');
    const containerUpcoming = $('#upcomingList');
    const containerPayments = $('#paymentsList');

    // recupero dati
    const res = await fetch('../api/bookings_tutor.php');
    const data = await res.json();
    if (!data.success) {
        alert('Errore caricamento lezioni: ' + data.message);
        containerHistory.innerHTML = 'Errore nel caricamento';
        return;
    }

    // inizializzazione container e variabili
    containerUpcoming.innerHTML = '';
    containerHistory.innerHTML = '';
    containerPayments.innerHTML = '';
    let past = 0;
    let next = 0;
    let toHave = 0;
    const paymentsByStudent = {};

    // loop su tutte le prenotazioni, suddivise in future e passate
    for (let i = 0; i < data.bookings.length; i++) {
        // dati per gli slot
        const s = data.bookings[i];
        const isDone = (new Date(s.date + 'T' + s.time) < new Date()); 
        const isPaid = (s.paid == 1);
        let mode, price, container;
        if (s.chosenMode == 0) {
            mode = s.mode;
            price = (s.mode === 'online') ? s.cost_online : s.cost_presenza;
        }
        else if (s.chosenMode == 1) {
            mode = 'online';
            price = s.cost_online;
        }
        else {
            mode = 'presenza';
            price = s.cost_presenza;
        }

        if (isDone) {
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

        // head = studente + data
        const head = document.createElement('div');
        head.classList.add('head');
        wrapper.appendChild(head);
        
        const strong = document.createElement('strong');
        strong.textContent = s.student_name;
        head.appendChild(strong);
        head.appendChild(document.createTextNode(displayDate(s.date) + ' ' + formatTime(s.time)));

        // meta = modalità + prezzo
        const meta = document.createElement('div');
        meta.classList.add('meta');
        wrapper.appendChild(meta);
        meta.appendChild(document.createTextNode('Modalità: ' + mode));
        meta.appendChild(document.createElement('br'));
        meta.appendChild(document.createTextNode('Prezzo: €' + price));

        // stato pagamento (solo per lezioni concluse)
        if (isDone) {
            const status = document.createElement('span');
            status.textContent = isPaid ? 'Pagato' : 'In attesa di pagamento';
            status.style.color = isPaid ? 'green' : '#b00020';
            status.style.fontWeight = 'bold';
            wrapper.appendChild(status);
        }

        // creazione struttura dati per tab pagamenti        
        if (isDone && !isPaid) {
            toHave += parseFloat(price);

            if (!paymentsByStudent[s.student_name]) {
                paymentsByStudent[s.student_name] = {
                    student_id: s.student_id,
                    total: 0,
                    lessons: []
                };
            }

            paymentsByStudent[s.student_name].total += parseFloat(price);
            paymentsByStudent[s.student_name].lessons.push({
                booking_id: s.booking_id,
                date: s.date,
                time: s.time,
                mode: mode,
                price: price
            });
        }
    }

    // creazione slots pagamenti
    if (toHave > 0) {
        for (const [studentName, sData] of Object.entries(paymentsByStudent)) {
            // div = head + lista lezioni
            const wrapper = document.createElement('div');
            wrapper.classList.add('slot');
            containerPayments.appendChild(wrapper);
            
            // head =  div sx + bottone pagamento totale
            const head = document.createElement('div');
            head.classList.add('head');
            wrapper.appendChild(head);

            // div sx = studente + totale dovuto
            const leftDiv = document.createElement('span');
            head.appendChild(leftDiv);
            
            const strong = document.createElement('strong');
            strong.textContent = studentName;
            leftDiv.appendChild(strong);
            
            const span = document.createElement('span');
            span.classList.add('badge', 'warn');
            span.textContent = 'Totale: €' + sData.total.toFixed(2);
            leftDiv.appendChild(span);

            // bottone pagamento totale
            const payAllBtn = document.createElement('button');
            payAllBtn.textContent = 'Salda tutto';
            payAllBtn.classList.add('btn');
            head.appendChild(payAllBtn);
            payAllBtn.addEventListener('click', async () => {
                if (!confirm('Confermi di voler segnare come pagate TUTTE le lezioni di ' + studentName + '?'))
                    return;

                payAllBtn.disabled = true;
                payAllBtn.textContent = '...';

                const res = await fetch('../api/pay_all.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ student_id: sData.student_id })
                });
                if (!res.ok)
                    throw new Error('HTTP error! status: ' + res.status);

                const data = await res.json();
                if (data.success) { // in caso di successo ricarica le stats
                    alert(data.message);
                    await loadStats();
                }
                else {
                    alert('Errore: ' + data.message);
                    payAllBtn.disabled = false;
                    payAllBtn.textContent = 'Salda tutto';
                }
            });

            // lista lezioni
            const ul = document.createElement('ul');
            wrapper.appendChild(ul);
            sData.lessons.forEach(lesson => {
                const li = document.createElement('li');
                ul.appendChild(li);

                const infoSpan = document.createElement('span');
                infoSpan.textContent = displayDate(lesson.date) + ' ' + formatTime(lesson.time) + ' ' + lesson.mode;
                li.appendChild(infoSpan);

                // bottone pagamento singolo
                const singleBtn = document.createElement('button');
                singleBtn.classList.add('btn-small');
                singleBtn.textContent = 'Salda';
                li.appendChild(singleBtn);
                singleBtn.addEventListener('click', async () => {
                    if (!confirm('Confermi il pagamento di ' + lesson.price + ' per questa singola lezione?'))
                        return;

                    singleBtn.disabled = true;
                    singleBtn.textContent = '...';

                    const res = await fetch('../api/pay_single.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ booking_id: lesson.booking_id })
                    });
                    if (!res.ok)
                        throw new Error('HTTP error! status: ' + res.status);

                    const data = await res.json();
                    if (data.success)
                        await loadStats(); // ricarica le stats in caso di successo
                    else {
                        alert('Errore: ' + data.message);
                        singleBtn.disabled = false;
                        singleBtn.textContent = 'Salda';
                    }
                });
            });
        }
    }

    // sidebar stats
    $('#statUpcoming').textContent = next;
    $('#statHours').textContent = past;
    $('#statDue').textContent = '€' + toHave.toFixed(2);

    if (next === 0) containerUpcoming.innerHTML = '<div class="empty">Nessuna lezione futura.</div>';
    if (past === 0) containerHistory.innerHTML = '<div class="empty">Nessuna lezione passata.</div>';
    if (toHave === 0) containerPayments.innerHTML = '<div class="empty">Nessun pagamento in sospeso.</div>';
}


/* ----- tab configurazione ----- */
async function loadConfig() {
    console.log('loadConfig called');
    // recupero container
    const container = $('#configList');
    container.innerHTML = 'Caricamento configurazione...';
    container.className = '';

    //recupero dati
    const res = await fetch('../api/config_get.php');
    const data = await res.json();

    if (!data.success) {
        alert('Errore caricamento config: ' + data.message);
        container.innerHTML = 'Errore caricamento dati.';
        return;
    }

    // inizializzazione container e variabili
    container.innerHTML = '';
    const profile = data.profile;
    const allSubs = data.all_subjects;
    const mySubs = data.my_subjects;

    // form = descrizione + tariffe + materie
    const formWrapper = document.createElement('div');
    formWrapper.classList.add('config-form');
    container.appendChild(formWrapper);

    // descrizione
    const groupDesc = document.createElement('div');
    groupDesc.classList.add('form-group');
    formWrapper.appendChild(groupDesc);
    
    const lblDesc = document.createElement('label');
    lblDesc.textContent = 'Descrizione (max 500 car.):';
    groupDesc.appendChild(lblDesc);
    
    const txtDesc = document.createElement('textarea');
    txtDesc.value = profile.description || '';
    txtDesc.rows = 5;
    groupDesc.appendChild(txtDesc);

    // tariffe = online + presenza
    const groupCost = document.createElement('div');
    groupCost.classList.add('form-row');
    formWrapper.appendChild(groupCost);

    // online
    const divOnline = document.createElement('div');
    divOnline.classList.add('form-group');
    groupCost.appendChild(divOnline);
    
    const lblOnline = document.createElement('label');
    lblOnline.textContent = 'Tariffa Online (€):';
    divOnline.appendChild(lblOnline);
    
    const inpOnline = document.createElement('input');
    inpOnline.type = 'number';
    inpOnline.step = '0.5';
    inpOnline.min = '0';
    inpOnline.value = profile.cost_online;
    divOnline.appendChild(inpOnline);

    // presenza
    const divPres = document.createElement('div');
    divPres.classList.add('form-group');
    
    const lblPres = document.createElement('label');
    groupCost.appendChild(divPres);
    lblPres.textContent = 'Tariffa Presenza (€):';
    divPres.appendChild(lblPres);
    
    const inpPres = document.createElement('input');
    inpPres.type = 'number';
    inpPres.step = '0.5';
    inpPres.min = '0';
    inpPres.value = profile.cost_presenza;
    divPres.appendChild(inpPres);

    // materie
    const groupSub = document.createElement('div');
    groupSub.classList.add('form-group');
    formWrapper.appendChild(groupSub);
    
    const lblSub = document.createElement('label');
    lblSub.textContent = 'Seleziona le materie che insegni:';
    groupSub.appendChild(lblSub);
    
    const subContainer = document.createElement('div');
    subContainer.classList.add('checkbox-grid');
    groupSub.appendChild(subContainer);
    
    allSubs.forEach(sub => {
        // div wrapper per ogni riga per forzare l'andata a capo
        const row = document.createElement('div');
        subContainer.appendChild(row);
        
        const label = document.createElement('label');
        label.classList.add('checkbox-item');
        row.appendChild(label);
        
        const chk = document.createElement('input');
        chk.type = 'checkbox';
        chk.value = sub.id;
        chk.name = 'subjects';
        
        if (mySubs.some(myId => myId == sub.id))
            chk.checked = true;
        label.appendChild(chk);
        label.appendChild(document.createTextNode(sub.name));
    });

    // bottone salvataggio
    const btnSave = document.createElement('button');
    btnSave.textContent = 'Salva Modifiche';
    btnSave.classList.add('btn');
    btnSave.style.marginTop = '20px'; // spazio extra sopra il bottone
    formWrapper.appendChild(btnSave);
    btnSave.addEventListener('click', async () => {
        const descVal = txtDesc.value.trim();
        const costOnVal = parseFloat(inpOnline.value);
        const costPrVal = parseFloat(inpPres.value);

        const selectedSubs = [];
        $$('input[name="subjects"]:checked').forEach(c => {
            selectedSubs.push(c.value);
        });

        if (descVal.length > 500) {
            alert('Descrizione troppo lunga.');
            return;
        }

        if (isNaN(costOnVal) || costOnVal < 0 || isNaN(costPrVal) || costPrVal < 0) {
            alert('Tariffe non valide.');
            return;
        }
        
        if (selectedSubs.length === 0) {
            if (!confirm('Nessuna materia selezionata. Continuare?'))
                return;
        }

        btnSave.disabled = true;
        btnSave.textContent = 'Salvataggio...';

        const res = await fetch('../api/config_update.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                description: descVal,
                cost_online: costOnVal,
                cost_presenza: costPrVal,
                subjects: selectedSubs
            })
        });
        if (!res.ok)
            throw new Error('HTTP error! status: ' + res.status);

        const data = await res.json();
        if (data.success) {
            alert('Salvato con successo!');
        }
        else {
            alert('Errore: ' + data.message);
        }

        btnSave.disabled = false;
        btnSave.textContent = 'Salva Modifiche';
    });

}

/* ----- logout ----- */
$('#logoutBtn').addEventListener('click', async () => {
    await fetch("../api/logout.php");
    window.location.href = '../index.html';
});


/* ----- inizializzazione ----- */
async function init() {
    console.log('init called');
    // recupero dati sessione e check
    const res = await fetch('../api/session.php');
    const data = await res.json();
    if (!data.logged || data.role !== 'tutor') {
        // non loggato come tutor, redirect alla login
        window.location.href = '../index.html';
        return;
    }
    $('#tutorName').textContent = 'Ciao, ' + data.username;

    // caricamento vari pannelli
    await loadCreatedSlots();
    await loadStats();
}
init();
