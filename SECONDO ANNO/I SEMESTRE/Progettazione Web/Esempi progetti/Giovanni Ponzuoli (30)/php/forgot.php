<!DOCTYPE html>
<html lang="en-US">

<head>
    <meta charset="utf-8">
    <title> Social Memory </title>

    <link rel="stylesheet" href="../css/forgot.css">
    <link rel="stylesheet" href="../css/footer.css">

    <script src='../js/forgot.js'></script>

</head>

<body onload="setUp()">
    <form id='usrForgot' onsubmit="validateUsrForgot()">
        <fieldset>
            <legend> Recover your Password</legend>

            <nav>
                Not a member?
                <a href='./signup.php'> Sign up now </a>
            </nav>

            <p>
                <label for='User'>Username</label> <br>
                <input type="text" id='User' placeholder="Enter your username"  maxlength="12" onkeyup="this.value = this.value.toLowerCase()">
            </p>

            <p>
                <input type="submit" name='Submit' value='Next'>
            </p>

            <p id="invalidUsrCredentials"> </p>

        </fieldset>
    </form>

    <script>
        const ufrm = document.getElementById('usrForgot');

        ufrm.addEventListener('submit', (e) => {
        e.preventDefault();
    })
    </script>

    <form id='pwdForgot' onsubmit="validatePwdForgot()">
        <fieldset id='notAnswered'>
            <legend> Recover your Password</legend>

            <p>
                <label for="Answer" id='recQuestion'>
                    
                </label><br>

                <input type="text" id="Answer" placeholder="Enter your answer"  maxlength="32">
            </p>

            <p>
                <input type="submit" name='Submit' value='Recover'>
            </p>

            <p id="invalidPwdCredentials"> </p>

        </fieldset>

        <fieldset id='answered'>
            <legend> Recover your Password</legend>

            <p id='showPassword'>

            </p>
        </fieldset>
    </form>

    <script>
        let pfrm = document.getElementById('pwdForgot');

        pfrm.addEventListener('submit', (e) => {
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