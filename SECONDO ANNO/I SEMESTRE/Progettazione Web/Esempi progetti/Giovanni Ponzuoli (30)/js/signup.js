function setUp() {
    document.getElementById('invalidCredentials').style.display = 'none';
}

function validateSignup() {

    //Validazione della resitrazione sul DB
    let x = new XMLHttpRequest();
    x.open('POST', '../php/signup_validation.php', true);

    x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let inputs = document.getElementsByTagName('input');

    let usr = inputs[0].value;
    let pwd = inputs[1].value;
    let cpd = inputs[2].value;
    let qst = document.getElementById('Question').value;
    let ans = inputs[3].value;

    x.send("usr=" + usr + "&pwd=" + pwd + "&cpd=" + cpd + "&qst=" + qst + "&ans=" + ans);

    x.onload = function() {
        if (JSON.parse(x.responseText) == "Good") {
            window.location.href = '../php/login.php';
        } else {
            document.getElementById('invalidCredentials').firstChild.nodeValue = JSON.parse(x.responseText);
            document.getElementById('invalidCredentials').style.display = 'inline';
        };
    }
}