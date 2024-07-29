<?php
                require_once "controllo.php";
                if(isset($_SESSION['UID'])){
                    echo "<a href='esci.php' id='esci'>
                           
                                Esci
                             
                                </a>";
        
                    $nome = $_SESSION['Nome'];
                    $cognome = $_SESSION['Cognome'];
                    
                    echo "<div id='nomeutente'>$nome $cognome</div>";

                }
                else 
                    echo "
                     
                            <a id='accesso' href='accedi.php'>
                                Area Riservata
                                </a>
                         
                       ";
                    

            ?>