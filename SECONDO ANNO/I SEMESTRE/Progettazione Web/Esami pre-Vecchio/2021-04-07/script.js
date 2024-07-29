function start_game(){
    // disabilita play button
    document.querySelector(".play").disabled = true;
    // start time
    let game_time = -1;
    let last_player = "computer"; // inizia il giocatore
    let player_score = 0;
    let computer_score = 0;
    let player_symbol = null;
    let computer_symbol = null;
    let game_interval = setInterval(() => {
        // avanzamento del tempo
        game_time += 1;
        update_game_time(game_time);

        // gestione turni
        if(game_time%3 == 0){
           new_turn();
        }

        // gestione punteggio
        if(game_time%6 == 0 && game_time != 0){
            // cerco input giocatore
            let target = document.querySelectorAll(".player-selection");
            for(let i = 0; i < target.length; i++){
                if(target[i].checked){
                    player_symbol = i;
                }
            }
            // console.log("Player: " + player_symbol);
            // console.log("Computer: " + computer_symbol);


            /*
            0 - carta
            1 - sasso
            2 - forbice
            */
            if(player_symbol == null){
                computer_score++;
            }else if(player_symbol == 0 &&  computer_symbol == 1){
                // carta vs sasso
                player_score++;
                
            }else if(player_symbol == 0 &&  computer_symbol == 2){
                // carta vs forbice
                computer_score++;
                
            }else if(player_symbol == 1 &&  computer_symbol == 0){
                // sasso vs carta
                computer_score++;
                
            }else if(player_symbol == 1 &&  computer_symbol == 2){
                // sasso vs forbice
                player_score++;
                
            }else if(player_symbol == 2 &&  computer_symbol == 0){
                // forbice vs carta
                player_score++;
                
            }else if(player_symbol == 2 &&  computer_symbol == 1){
                // forbice vs sasso
                computer_score++;
            }
        }

        update_score();

        // fine partita
        if(player_score >= 3 || computer_score >= 3){
            stop_time();
            console.log("Fine partita!");
            let vincitore = player_score > computer_score ? "Player" : "Computer";
            game_reset(vincitore);
        }

    }, 1000)




    function new_turn(){
        if(last_player == "computer"){
            // console.log("player turn " + game_time);
            
            change_player_selection_state();
            last_player = "player";
        }else{
            // console.log("computer turn " + game_time);

            change_player_selection_state();

            choose_random_symbol();

            last_player = "computer";
        }
    }

    function choose_random_symbol(){
        let target = document.querySelectorAll(".computer-selection");
    
        let value = Math.floor(Math.random()*3);
        target[value].checked = true;
        computer_symbol = value;
    }

    function change_player_selection_state(){
        // abilita e disabilita gli input del giocatore
        let target = document.querySelectorAll(".player-selection");
            // console.log(target);
            for(let i = 0; i < target.length; i++){
                target[i].disabled = !target[i].disabled;
            }
    }
    
    function update_score(){
        let player_score_out = document.querySelector(".player-score .value");
        let computer_score_out = document.querySelector(".computer-score .value");
        player_score_out.textContent = player_score;
        computer_score_out.textContent = computer_score;
    }

    function stop_time(){
        clearInterval(game_interval);
    }

    function game_reset(vincitore){
        document.querySelector(".time").textContent = '';
        document.querySelector(".player-score .value").textContent = '';
        document.querySelector(".computer-score .value").textContent = '';

        // finestra che comunica il vincitore
        let result_window = window.open("", "", "width=200,height=200");
        result_window.document.write("<p>" + vincitore + "</p>");
        result_window.document.close();
        setTimeout(() => {
            result_window.close();

            // riattiva tasto play
            document.querySelector(".play").disabled = false;
        }, 5000)

    }

}
function update_game_time(time){
    let target = document.querySelector(".time");
    target.textContent = time;
}




function reset(){
    // reset time

    // reset score

    // enable play button
}