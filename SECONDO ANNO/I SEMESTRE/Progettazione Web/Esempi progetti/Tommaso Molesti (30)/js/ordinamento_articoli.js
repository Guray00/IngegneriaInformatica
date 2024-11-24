function buildTable() {
    if(!articoli.length)
        return;

    const table = document.getElementById("article-table");
    table.innerHTML = "";

    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');

    const nameHeader = document.createElement('th');
    nameHeader.innerText = "Nome articolo";
    headerRow.appendChild(nameHeader);

    const actionsHeader = document.createElement('th');
    actionsHeader.innerText = "Azioni";
    headerRow.appendChild(actionsHeader);

    thead.appendChild(headerRow);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    articoli.sort((a, b) => a.sort_index - b.sort_index);

    const rows = articoli.map((el, index) => {
        const row = document.createElement('tr');
        row.id = "article-" + el.id;

        const name = document.createElement('td');
        name.innerText = el.name;
        row.appendChild(name);

        const arrows = document.createElement('td');

        const up = document.createElement('button');
        up.innerText = "▲";
        up.onclick = () => onOrderChange(el.id, "up");
        if (index === 0) {
            up.disabled = true;
        }

        const down = document.createElement('button');
        down.innerText = "▼";
        down.onclick = () => onOrderChange(el.id, "down");
        if (index === articoli.length - 1) {
            down.disabled = true;
        }

        arrows.appendChild(up);
        arrows.appendChild(down);
        row.appendChild(arrows);

        return row;
    });

    rows.forEach(row => tbody.appendChild(row));
    table.appendChild(tbody);
}

function onOrderChange(id, direction) {
    const saveBtn = document.getElementById('save-btn');
    saveBtn.disabled = false;
    const index = articoli.findIndex(el => el.id === id);
    if (index !== -1) {
        if (direction === "up" && index > 0) {
            [articoli[index].sort_index, articoli[index - 1].sort_index] = [articoli[index - 1].sort_index, articoli[index].sort_index];
        } else if (direction === "down" && index < articoli.length - 1) {
            [articoli[index].sort_index, articoli[index + 1].sort_index] = [articoli[index + 1].sort_index, articoli[index].sort_index];
        }
        buildTable();
    }
}

function saveOrder() {

    const orderedArticles = articoli.map(el => ({
        id: el.id,
        sort_index: el.sort_index
    }));

    fetch('update_order.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(orderedArticles)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const saveBtn = document.getElementById('save-btn');
            saveBtn.disabled = true;
        } else {
            alert('Errore nel salvataggio dell\'ordine');
        }
    })
    .catch(error => {
        console.error('Errore nel salvataggio:', error);
        alert('Si è verificato un errore');
    });
}