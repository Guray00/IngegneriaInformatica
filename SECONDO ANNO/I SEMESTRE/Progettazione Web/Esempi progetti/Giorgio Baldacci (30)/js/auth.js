// auth.js

async function login(role, username, password) {
    console.log("login called", {role, username, password});
    const res = await fetch("api/login.php", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({role, username, password})
    });

    return await res.json();
}

async function register(role, username, password) {
    console.log("register called", { role, username, password });
    const res = await fetch("../api/register.php", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({role, username, password})
    });

    return await res.json();
}

async function logout() {
    console.log("logout called");
    await fetch("../api/logout.php");
}