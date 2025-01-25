<!DOCTYPE html>

<!--Firefox 92.0.1 e Chrome 94.0.4606.61. -->

<html>

<head>
    <title>Simple Go Game</title>

    <link rel="stylesheet" href="../css/main.css" />
    <link rel="stylesheet" href="../css/topNavigation.css" />
    <link rel="stylesheet" href="../css/leftNavigation.css" />

    <style>
        form {
            /* background-color: aliceblue; */
            border-radius: 20px;

            margin-bottom: 50px;
            padding: 30px;

            width: fit-content;
            max-width: 50%;

            font-size: large;
        }

        fieldset {
            border-radius: 20px;
            padding: 10px 20px;
            padding-bottom: 25px;
        }

        legend {
            text-align: center;
            font-weight: bold;
            font-size: 1.5em;
            font-style: oblique;
        }

        label {
            font-weight: bold;
            font-family: sans-serif;

            white-space: nowrap;
        }

        fieldset {
            border-radius: 20px;
            box-shadow: 2px 2px 5px lightgray;
        }

        form p {
            display: flex;
            justify-content: flex-end;
            gap: 10px;

            margin: 20px 10px;

            font-size: large;
        }

        form input {
            font-size: large;
            text-align: center;
            width: 50%;

            border: 1px solid rgb(0, 0, 0, 0.3);
            border-radius: 5px;
        }

        p.submit {
            justify-content: center;
            margin-top: 30px;

        }

        input[type='submit'] {

            width: fit-content;
            padding: 10px 30px;

            border-radius: 10px;
            font-weight: bold;
            font-size: 1.2em;

            background-color: #2b89e1;
            color: white;
        }

        [hidden] {
            display: none;
        }

        #recover .question {
            font-size: large;

        }

        .error {
            font-weight: 600;
            font-style: italic;
            color: #ff4600;
        }
    </style>
</head>

<body>
    <?php include '../php/topNavigation.inc.php' ?>
    <?php include '../php/leftNavigation.inc.php' ?>

    <main>

        <form id="login">
            <fieldset>
                <legend>Login</legend>
                <p>
                    <label for="username">Username</label>
                    <input type="text" name="username" required  />
                </p>
                <p>
                    <label for="password">Password</label>
                    <input type="password" name="password" required />
                </p>
                <p class="submit">
                    <input type="submit" value="Login" />
                </p>

                <p class="login error" hidden>Incorrect credentials</p>
                <p>
                    <a href="#recover" onclick="document.getElementById('recover').hidden = false">Forgot password?</a>
                </p>
            </fieldset>
        </form>
        

        <form id="recover" hidden>
            <fieldset>
                <legend>Recover Account</legend>

                <p class="username">
                    <label for="username">Username</label>
                    <input type="text" name="username" />
                </p>

                <p class="question" hidden>deafult question</p>

                <p class="answer" hidden>
                    <label for="answer">Answer</label>
                    <input type="text" name="answer" />
                </p>

                <p class="password" hidden>
                    <label for="password"> New Password</label>
                    <input type="password" name="password" minlength="5" />
                </p>
                <p class="confirm" hidden>
                    <label for="confirm">Confirm Password</label>
                    <input type="password" name="confirm" minlength="5" />
                </p>

                <p class="recover error" hidden>Incorrect credentials</p>

                <p class="submit">
                    <input type="submit" value="Recover" />
                </p>
            </fieldset>
        </form>

        <form id="register">
            <fieldset>
                <legend>Sign Up</legend>
                <p>
                    <label for="username">Username</label>
                    <input type="text" name="username" required minlength="4" />
                </p>
                <p>
                    <label for="password">Password</label>
                    <input type="password" name="password" required minlength="5" />
                </p>
                <p>
                    <label for="confirm">Confirm Password</label>
                    <input type="password" name="confirm" required minlength="5" />
                </p>
                <p>
                    <label for="question">Security Question</label>
                    <input type="text" list="choices" name="question" required />
                    <datalist id="choices">
                        <option value="In what city were you born?"></option>
                        <option value="What is the name of your favorite pet?"></option>
                        <option value="What is your mother's maiden name?"></option>
                        <option value="What high school did you attend?"></option>
                        <option value="What is the name of your first school?"></option>
                        <option value="What was the make of your first car?"></option>
                        <option value="What was your favorite food as a child?"></option>
                    </datalist>
                </p>
                <p>
                    <label for="answer">Answer</label>
                    <input type="text" name="answer" required minlength="3" />
                </p>

                <p class="register error" hidden>Something went wrong...</p>

                <p class="submit">
                    <input type="submit" value="Create Account" />
                </p>
            </fieldset>
        </form>
    </main>


    <script>
        const formLogin = document.getElementById("login");
        const formRecover = document.getElementById("recover");
        const formRegister = document.getElementById("register");

        formLogin.onsubmit = login;
        formRecover.onsubmit = recover;
        formRegister.onsubmit = register;

        // Login Handler
        function login(event) {
            event.preventDefault();

            let data = new FormData(formLogin);
            let x = new XMLHttpRequest();
            x.open("post", "../php/login.php");

            x.onload = () => {
                const response = JSON.parse(x.response);

                if (response["login"] === true) {
                    window.location.href = "../html/home.php";
                } else {
                    console.log(response);
                    const errorMessage = document.querySelector(".login.error");
                    errorMessage.hidden = false;
                }
            };

            x.onerror = (event) => console.log(event);
            x.send(data);
        }

        // Recover Handler
        function recover(event) {
            event.preventDefault();

            const [, question, answer, password, confirm, error] = formRecover.getElementsByTagName("p");

            const steps = ["getQuestion", "verify", "changePassword"];
            let index = answer.hidden ? 0 : (password.hidden ? 1 : 2);
            let step = steps[index];

            let x = new XMLHttpRequest();
            x.open("post", "../php/recover.php");
            x.onerror = (event) => console.log(event);
            x.onload = () => {
                const response = JSON.parse(x.response);
                console.log(response);

                if (response["recover"] === true) {
                    error.hidden = true;

                    switch (response["step"]) {
                        case "getQuestion":
                            question.hidden = false;
                            answer.hidden = false;

                            answer.children[1].required = true;

                            question.textContent = response.question ? response.question : "No question";
                            break;
                        case "verify":
                            password.hidden = confirm.hidden = false;

                            password.children[1].required = true;
                            confirm.children[1].required = true;
                            break;
                        case "changePassword":
                            alert('Password changed! Try to login now!');
                            window.location.reload();
                    }
                } else {
                    const errorMessage = document.querySelector(".recover.error");
                    errorMessage.hidden = false;
                    errorMessage.textContent = response['error'];
                }
            };

            let data = new FormData(formRecover);
            data.append("step", step);
            x.send(data);
        }

        // Register Handler
        function register(event) {
            event.preventDefault();

            const [username, password, confirm, question, answer] = formRegister.getElementsByTagName('input');

            if (password.value != confirm.value) {
                // error
            }

            const data = new FormData(formRegister);

            fetch('../php/register.php', {
                    method: 'post',
                    body: data,
                })
                .then(response => response.json())
                .then(data => {
                    if (data["register"] === true) {
                        window.location.href = "../html/home.php";
                    } else {
                        console.log(data);
                        const errorMessage = document.querySelector(".register.error");
                        errorMessage.hidden = false;
                        errorMessage.textContent = data['error'];
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });


        }
    </script>
</body>

</html>