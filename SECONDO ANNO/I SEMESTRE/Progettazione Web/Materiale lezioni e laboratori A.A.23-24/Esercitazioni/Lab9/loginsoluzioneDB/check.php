<?php

    // NOTA: il meccanismo di segnalazione degli errori per alcune delle funzioni
    // utilizzate dipende dalla versione di PHP. 
    // Per esempio a partire dalla versione 8.10 il valore di default
    // di mysqli_report e' MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT
    // dove
    // MYSQLI_REPORT_ERROR	Report errors from mysqli function calls
    // MYSQLI_REPORT_STRICT	Throw mysqli_sql_exception for errors instead of warnings
    // Eventualmente modificare il codice di gestione degli errori sulla base della
    // specifica versione di PHP utilizzata.

    // La funzione empty restituisce false se la variabile esiste e non e' 
    // vuota, altrimenti restituisce true
    if (empty($_POST["username"])){
        echo ("<script>alert('Errore: il nome utente non può essere vuoto'); 
                       window.history.back();
               </script>");
        exit();
    }
    if (empty($_POST["password"])){
        echo ("<script>alert('Errore: la password non può essere vuota'); 
                       window.history.back();
               </script>");
        exit();
    }

	// Connessione al database
	$db_connection = mysqli_connect('localhost', 'root', '', 'users');
    if ( mysqli_connect_errno() ) {
		exit('Connessione a database non riuscita. (' . mysqli_connect_error() . ')');
	}

    if (isset($_POST["register"])){
        //Dobbiamo registrare l'utente nel sistema
        $hash =  password_hash($_POST["password"], PASSWORD_BCRYPT);
		$query = "INSERT INTO users.login (usr_name, hash) VALUES (?,?)";
		$statement = mysqli_prepare($db_connection, $query);
        mysqli_stmt_bind_param($statement, "ss", $_POST["username"], $hash);

        if (!mysqli_stmt_execute($statement)){
            //La query è fallita -> l'utente esiste gia
            echo ("<script>alert('Errore: la utente gia registrato'); 
                           window.history.back(); 
                   </script>");
            exit();
        }else{
            echo ("<script>alert('Utente registrato con successo'); 
                           window.history.back();
                   </script>");
            exit();
        }
        
    }else{
        //Dobbiamo loggare l'utente nel sistema
        $query = "SELECT hash FROM users.login WHERE usr_name = ?";
        $statement = mysqli_prepare($db_connection, $query);
        mysqli_stmt_bind_param($statement, "s", $_POST["username"]);
        mysqli_stmt_execute($statement);
    
        // Binding del risultato alla variabile $hash
        mysqli_stmt_bind_result($statement, $hash);
        while (mysqli_stmt_fetch($statement)){
            if (password_verify($_POST["password"], $hash)) {
                echo ("<script>alert('Login avvenuto con successo'); 
                            window.history.back();
                       </script>");
                exit();
            } 
        }
        echo ("<script>alert('Login fallito'); 
                            window.history.back();
               </script>");

    }
?>