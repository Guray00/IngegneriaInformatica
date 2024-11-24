function confirmImport() {
    var selectElement = document.getElementById("import_magazzino");
    var selectedValue = selectElement.options[selectElement.selectedIndex].value;
    if (selectedValue) {
        return confirm("Sei sicuro di voler importare il magazzino da un'altra festa? Gli articoli importati avranno tutti quantità 0 con tracking della quantità attivo\nPotrai modificarli in un secondo momento.");
    }
    return true;
}