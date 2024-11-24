let selectedArticles = [];

function addToList(articleId, articleName, articlePrice, availableQuantity, tracking_quantity, sort_index) {
    // Cerco se l'articolo esiste già nella lista degli articoli selezionati
    let existingArticle = selectedArticles.find(article => article.id === articleId);

    // Se l'articolo è già nella lista, aumento la quantità se non supera la quantità disponibile,
    // oppure se il tracciamento della quantità è disattivato
    if (existingArticle) {
        if (existingArticle.quantity < availableQuantity || !Boolean(Number(tracking_quantity))) {
            existingArticle.quantity++;
            existingArticle.subTotal += Number(articlePrice);
        }
    } else {
        // Se l'articolo non è nella lista, lo creo e lo aggiungo alla lista
        const newItem = {
            id: articleId,
            name: articleName,
            quantity: 1,
            subTotal: Number(articlePrice),
            tracking_quantity: Boolean(Number(tracking_quantity)),
            maxQuantity: availableQuantity,
            sort_index: Number(sort_index)
        };
        selectedArticles.push(newItem);
    }

    updateArticleList();
    updateTotal();
    updateSubmitButton();
    updateArticleButtons();
}

function updateArticleButtons() {
    selectedArticles.forEach(article => {
        const button = document.getElementById('article-' + article.id);
        // Se la quantità ordinata è >= della quantià massima ordinabile e se l'articolo
        // ha la quantità tracciata, allora disabilito il bottone.
        // Vuol dire che l'articolo è terminato e non può essere più ordinabile
        if (article.quantity >= article.maxQuantity && article.tracking_quantity) {
            button.disabled = true;
        } else {
            button.disabled = false;
        }
    });
}


function onNameChange() {
    updateSubmitButton();
}

function updateSubmitButton() {
    const orderName = document.getElementById("order_name");
    const aggiungiBtn = document.getElementById("aggiungi-btn");

    if (selectedArticles.length > 0 && orderName?.value?.trim() !== "") {
        aggiungiBtn.disabled = false;
    } else {
        aggiungiBtn.disabled = true;
    }
}

function removeFromList(articleId) {
    // Cerco l'articolo specifico nella lista degli articoli selezionati
    const existingArticle = selectedArticles.find(article => article.id === articleId);
    const price = existingArticle.subTotal / existingArticle.quantity;
    
    if (existingArticle) {
        // Decremento la quantità e aggiorna il totale parziale per l'articolo
        existingArticle.quantity--;
        existingArticle.subTotal -= price;
        // Rimuovo l'articolo dalla lista se la quantità scende a 0
        if (existingArticle.quantity <= 0) {
            selectedArticles = selectedArticles.filter(article => article.id !== articleId);
        }
        
        updateArticleList();
        updateTotal();
        updateSubmitButton();
        updateArticleButtons();
    }
}


function updateArticleList() {
    const articleTable = document.getElementById("article-table");
    articleTable.innerHTML = "";

    if (selectedArticles.length === 0) {
        articleTable.style.display = "none";
        return;
    } else {
        articleTable.style.display = "";
    }

    const tableHeader = document.createElement("thead");
    tableHeader.classList.add("table-header");
    const rowHeader = document.createElement("tr");
    
    const nameHeader = document.createElement("td");
    nameHeader.textContent = "Nome";
    rowHeader.appendChild(nameHeader);
    
    const quantityHeader = document.createElement("td");
    quantityHeader.textContent = "Quantità";
    rowHeader.appendChild(quantityHeader);
    
    const subTotalHeader = document.createElement("td");
    subTotalHeader.textContent = "Parziale";
    rowHeader.appendChild(subTotalHeader);

    const deleteContainer = document.createElement("td");
    deleteContainer.textContent = "";
    rowHeader.appendChild(deleteContainer);
    
    tableHeader.appendChild(rowHeader);
    articleTable.appendChild(tableHeader);
    
    const tableBody = document.createElement("tbody");

    selectedArticles.sort((a, b) => a.sort_index - b.sort_index);

    selectedArticles.forEach(article => {
        const row = document.createElement("tr");
        row.classList.add("table-row");
        
        const name = document.createElement("td");
        name.textContent = article.name;
        row.appendChild(name);
        
        const quantity = document.createElement("td");
        quantity.textContent = article.quantity;
        row.appendChild(quantity);
        
        const subTotal = document.createElement("td");
        subTotal.textContent = article.subTotal.toFixed(2) + " €";
        row.appendChild(subTotal);

        const deleteBtnContainer = document.createElement("td");
        deleteBtnContainer.classList.add("delete-btn-container");

        const deleteBtn = document.createElement("button");
        deleteBtn.textContent = "-";
        deleteBtn.classList.add("delete-btn");
        deleteBtn.onclick = () => removeFromList(article.id);
        deleteBtnContainer.appendChild(deleteBtn);

        row.appendChild(deleteBtnContainer);
        tableBody.appendChild(row);
    });

    articleTable.appendChild(tableBody);

    const selectedArticlesInput = document.getElementById("selectedArticlesInput");
    selectedArticlesInput.value = JSON.stringify(selectedArticles);
}

function updateTotal() {
    const total = document.getElementById("total");
    let totale = 0;
    selectedArticles.forEach(article => {
        totale += article.subTotal;
    });

    total.textContent = "Totale : " + totale.toFixed(2) + " €";
}

