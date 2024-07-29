<!DOCTYPE html>
<html lang="en-US">

<head>
    <meta charset="utf-8">
    <title> Social Memory </title>

    <link rel="stylesheet" href="../css/login.css">
    <link rel="stylesheet" href="../css/footer.css">

    <script src='../js/login.js'></script>

</head>

<body onload="setUp()">
    <form id='leftLogin' onsubmit="validateLogin(0)">
        <fieldset id='leftNotLogged'>
            <legend> Blue Player Login</legend>

            <nav>
                Not a member?
                <a href='./signup.php'> Sign up now </a>
            </nav>

            <p>
                <label for='leftUser'>Username</label> <br>
                <input type="text" id='leftUser' placeholder="Enter your username" maxlength="12" onkeyup="this.value = this.value.toLowerCase()">
            </p>

            <p>
                <label for='leftPassword'>Password</label> <br>
                <input type="password" id='leftPassword' placeholder="Enter your password" maxlength="32">
            </p>

            <nav>
                Forgot Password? <a href='./forgot.php'> Click here</a>
            </nav>

            <p>
                <input type="submit" id='leftSubmit' value='Login'>
            </p>

            <p id="invalidLeftCredentials"> </p>

        </fieldset>
    </form>

    <script>
        const lfrm = document.getElementById('leftLogin');

        lfrm.addEventListener('submit', (e) => {
        e.preventDefault();
    })
    </script>

    <form id='rightLogin' onsubmit="validateLogin(1)">
        <fieldset id='rightNotLogged'>
            <legend> Red Player Login</legend>

            <nav>
                Not a member?
                <a href='./signup.php'> Sign up now </a>
            </nav>

            <p>
                <label for='rightUser'>Username</label> <br>
                <input type="text" id='rightUser' placeholder="Enter your username" maxlength="12" onkeyup="this.value = this.value.toLowerCase()">
            </p>

            <p>
                <label for='rightPassword'>Password</label> <br>
                <input type="password" id='rightPassword' placeholder="Enter your password" maxlength="32">
            </p>

            <nav>
                Forgot Password? <a href='./forgot.php'> Click here</a>
            </nav>
    
            <p>
                <input type="submit" id='rightSubmit' value='Login'>
            </p>

            <p id="invalidRightCredentials"> </p>

        </fieldset>
    </form>

    <script>
        const rfrm = document.getElementById('rightLogin');

        rfrm.addEventListener('submit', (e) => {
        e.preventDefault();
    })
    </script>

    <footer id='navigationBar'>
        <a href="../index.php" >
            <img id='home' src='../images/footer/uncheckedHome.png' width="60" height="60" alt='Home button'>
        </a>
    </footer>

</body>
</html>