const colori = ["#00563e", "#560000", "#005606", "#0013a9", "orange"];
function init(){
    
    let tornei = document.querySelectorAll(".torneo");
    
    for(let i of tornei){
        let numerocasuale = Math.floor(Math.random()*5);
        i.style.backgroundColor = colori[numerocasuale];
        
    }
}