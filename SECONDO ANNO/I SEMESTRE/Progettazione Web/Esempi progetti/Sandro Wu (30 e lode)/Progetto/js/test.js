
let boardSize = 13;
let gameBox = document.getElementById("gameBox");

let go = new GoGame(gameBox, boardSize);
// delete go;




// keys to show board steps
let step = 3;
let firstTime = true;

document.onkeydown = function (e) {
    e = (!e) ? window.event : e;
    var key = e.code;

    if (firstTime) {
        step = go.logic.currentStep;
        firstTime = !firstTime;
    }

    switch (key) {
        case 'ArrowLeft': step--; break;
        case 'ArrowRight': step++; break;
        default: return;
    }

    step = Math.max(step, 0);
    step = Math.min(step, go.logic.currentStep);

    go.showBoardStateAt(step);

}