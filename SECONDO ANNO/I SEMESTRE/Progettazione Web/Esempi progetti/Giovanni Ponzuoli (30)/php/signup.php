<!DOCTYPE html>
<html lang="en-US">

<head>
    <meta charset="utf-8">
    <title> Social Memory </title>

    <link rel="stylesheet" href="../css/signup.css">
    <link rel="stylesheet" href="../css/footer.css">

    <script src="../js/signup.js"></script>    

</head>

<body onload="setUp()">

    <form id='register' onsubmit="validateSignup()">
        <fieldset>
            <legend> Join Social Memory </legend>

            <nav>
                Already have an account?
                <a href='./login.php'> Log in </a>
            </nav>

            <p>
                <label for='User'>Username</label><br>
                <input type="text" id='User' placeholder="Enter your username"  maxlength="12" onkeyup="this.value = this.value.toLowerCase()">
            </p>

            <p>
                <label for='Password'>Password</label> <br>
                <input type="password" id='Password' placeholder="Enter your password" maxlength="32">
            </p>

            <p>
                <label for='ConfirmPassword'>Confirm Password</label> <br>
                <input type="password" id='ConfirmPassword' placeholder="Confirm your password" maxlength="32">
            </p>

            <p>
                <label for="Question">Recovery Question</label><br>
                <select id="Question">
                    <option selected disabled hidden>Select your question</option>

                    <?php 
                    
                    //Querying e Fetching

                    if(session_status() === PHP_SESSION_NONE){
                        session_start();
                    }
                
                    require_once '../config/database.php';
                
                    $connection = new cncDB();
                    $pdo = $connection->getPD0();

                    $sql = 'SELECT * FROM recovery_question';
                    $result = $pdo->prepare($sql);
                    $result->execute();

                    $qst = $result->fetchAll(pdo::FETCH_ASSOC);
                    
                    foreach($qst as $item):?>
                        <option value="<?php echo $item['QuestionID']?>"  
                                label="<?php echo $item['QuestionBody']?>"> 
                        </option>                       
                    <?php endforeach;

                    $connection->close();
                    $pdo = null;
                    ?>
                </select>
            </p>

            <p>
                <label for='Answer' >Recovery Answer</label> <br>
                <input type="text" id='Answer' placeholder="Enter your answer" maxlength="32">
            </p>

            <p>
                <input type="submit" name='Submit' value='Sign in'>
            </p>

            <p id="invalidCredentials">

            </p>

        </fieldset>

    </form>

    <script>
        const frm = document.getElementById('register');

        frm.addEventListener('submit', (e) => {
        e.preventDefault();
    })
    </script>

    <footer id='navigationBar'>
        <a href="../index.php" >
            <img id='home' src='../images/footer/uncheckedHome.png' width="60" height="60" alt='Home Button'>
        </a>
    </footer>

</body>
</html>