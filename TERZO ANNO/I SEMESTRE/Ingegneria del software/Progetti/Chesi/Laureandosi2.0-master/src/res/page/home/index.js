const SELECT_corso_laurea = document.querySelector("#form-input #corso_laurea");
const DATE_data_laurea = document.querySelector("#form-input #data_laurea");
const TEXTAREA_matricole = document.querySelector("#form-input #matricole");
const CHECKBOX_test = document.querySelector("#form-input #test");
const BUTTON_crea_report = document.querySelector("#form-input #crea_report");
const BUTTON_apri_report = document.querySelector("#form-input #apri_report");
const BUTTON_invia_report = document.querySelector("#form-input #invia_report");
const H2_titolo = document.querySelector("article > h2");

function showToast(message, error=false)
{
    let toast = document.createElement('div');
    toast.id = 'toast';

    time = message.length * 100 + 5000 * error ;

    toast.appendChild(document.createTextNode(message));
    document.body.appendChild(toast);

    setTimeout(function () {
        toast.classList.add("active", error ? "error" : null);
        setTimeout(function () {
            toast.classList.remove("active");
            setTimeout(function () {
                document.body.removeChild(toast);
            }, time + 500);
        },time);
    }, 500);
}

document.addEventListener("DOMContentLoaded", () => {
    fetch("?api=GETCorsiDiLaurea")
    .then((res) => res.json())
    .then((res) => {

        res.forEach((elem) => {
            let option = new Option(elem.cdl, elem["cdl-short"]);
            SELECT_corso_laurea.add(option, undefined);
        });

        DATE_data_laurea.min = new Date().toISOString().split("T")[0];

        BUTTON_crea_report.disabled = false;
        DATE_data_laurea.disabled = false;
        TEXTAREA_matricole.disabled = false;
        SELECT_corso_laurea.disabled = false;
        H2_titolo.classList.remove("loading");
    });
});

BUTTON_crea_report.addEventListener("click", (e) => {

    if (!SELECT_corso_laurea.checkValidity()) {
        SELECT_corso_laurea.reportValidity();
        return;
    }

    if (!DATE_data_laurea.checkValidity()) {
        DATE_data_laurea.reportValidity();
        return;
    }

    if (!TEXTAREA_matricole.checkValidity()) {
        TEXTAREA_matricole.reportValidity();
        return;
    }

    H2_titolo.classList.add("loading");

    (async() => {
        const res = await fetch("?api=POSTCreaReport", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                corso_laurea: SELECT_corso_laurea.value,
                data_laurea: DATE_data_laurea.value,
                matricole: TEXTAREA_matricole.value.split("\n").map((elem) => parseInt(elem.trim())),
                test: CHECKBOX_test.checked
            })
        });
        H2_titolo.classList.remove("loading");
        const json = await res.json();
    if (res.ok) {
        showToast(json.message);
    } else {
        showToast(json.message, true);
    }
    })();
});


BUTTON_apri_report.addEventListener("click", (e) => {

    if (!SELECT_corso_laurea.checkValidity()) {
        SELECT_corso_laurea.reportValidity();
        return false;
    }

    if (!DATE_data_laurea.checkValidity()) {
        DATE_data_laurea.reportValidity();
        return false;
    }

    fetch("?api=GETApriReport&corso_laurea=" + SELECT_corso_laurea.value + "&data_laurea=" + DATE_data_laurea.value)
    .then((res) => res.ok ? res.blob() : Promise.reject(res))
    .then((res) => window.open(window.URL.createObjectURL(res), '_blank').focus())
    .catch((err) => err.json().then((err) => showToast(err.message, true)));

});

BUTTON_invia_report.addEventListener("click", (e) => {

    if (!SELECT_corso_laurea.checkValidity()) {
        SELECT_corso_laurea.reportValidity();
        return false;
    }

    if (!DATE_data_laurea.checkValidity()) {
        DATE_data_laurea.reportValidity();
        return false;
    }

    if (!TEXTAREA_matricole.checkValidity()) {
        TEXTAREA_matricole.reportValidity();
        return false;
    }

    let matricole = TEXTAREA_matricole.value.split("\n").map((elem) => parseInt(elem.trim()));
    let corso_laurea = SELECT_corso_laurea.value;
    let data_laurea = DATE_data_laurea.value;

    SELECT_corso_laurea.disabled = true;
    DATE_data_laurea.disabled = true;
    TEXTAREA_matricole.disabled = true;
    BUTTON_invia_report.disabled = true;
    BUTTON_apri_report.disabled = true;
    BUTTON_crea_report.disabled = true;
    H2_titolo.classList.add("loading");

    (async function inviaReport()
    {
        const matricola = matricole.shift();
        const res = await fetch("?api=POSTInviaReport", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                corso_laurea: corso_laurea,
                data_laurea: data_laurea,
                matricola: matricola,
                test: CHECKBOX_test.checked
            })
        });
        const json = await res.json();
        if (res.ok) {
            showToast(json.message + "\n" + matricole.length + " report rimanenti.");
            if (matricole.length > 0) {
                await new Promise(resolve => {setTimeout(resolve, 10000)})
                await inviaReport();
            }
        } else if (res.status == 409) {
            if (matricole.length > 0) {
                await inviaReport();
            } else {
                showToast("Tutti i report sono già stati inviati.");
            }
        } else {
            showToast(json.message, true);
        }
    })().then(() => {
        SELECT_corso_laurea.disabled = false;
        DATE_data_laurea.disabled = false;
        TEXTAREA_matricole.disabled = false;
        BUTTON_invia_report.disabled = false;
        BUTTON_apri_report.disabled = false;
        BUTTON_crea_report.disabled = false;
        H2_titolo.classList.remove("loading");
    });
});