import React, {useState} from "react";
import { UpdateSessionCallback } from "./callback.js";
import "./signin.css"

export const SignIn = () => {
    const [showDropdown, setShowDropdown] = useState(false);
    const [loggedIn, setLoggedIn] = useState(false);
    const [activeUsername, setActiveUsername] = useState(undefined);
    const [sessionToken, setSessionToken] = useState(undefined);
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    const login = () => {
        fetch('/session', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ user: { email: username, password: password } })
        })
            .then(response => response.json())
            .then(data => {
                if (data.session_token) {
                    setLoggedIn(true);
                    setActiveUsername(username);
                    UpdateSessionCallback.trigger(data.session_token);
                    setSessionToken(data.session_token);
                } else {
                    alert("Login failed.");
                }
            })
            .catch(error => console.error("Login error:", error));
    };

    const createAccount = () => {
        fetch('/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ user: { email: username, password: password } })
        })
            .then(response => response.json())
            .then(data => {
                if (data.session_token) {
                    setLoggedIn(true);
                    setActiveUsername(username);
                    UpdateSessionCallback.trigger(data.session_token);
                    setSessionToken(data.session_token);
                } else {
                    alert("Account creation failed.");
                }
            })
            .catch(error => console.error("Account creation error:", error));
    };

    const signOut = () => {
        fetch('/session', {
            method: 'DELETE',
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
        })
            .then(response => {
                if (response.ok) {
                    setLoggedIn(false);
                    setActiveUsername(undefined);
                    UpdateSessionCallback.trigger(undefined);
                    setSessionToken(undefined);
                } else {
                    alert("Logout failed.");
                }
            })
            .catch(error => console.error("Logout error:", error));
    };

    const toggleDropdown = () => {
        setShowDropdown(!showDropdown);
    };

    return (
        <div>
            {!loggedIn ? (
                <>
                    <button id="sign_in_button" onClick={toggleDropdown}>SIGN IN</button>
                    {showDropdown && (
                        <div className="signin_dropdown">
                            <table className="username_password_table">
                                <tbody>
                                    <tr>
                                        <td>Username:</td>
                                        <td>
                                            <input
                                                type="text"
                                                name="username"
                                                autoComplete="username"
                                                value={username}
                                                onChange={(e) => setUsername(e.target.value)}
                                            />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Password (min 6 characters):</td>
                                        <td>
                                            <input
                                                type="password"
                                                name="password"
                                                minLength="6"
                                                autoComplete="current-password new-password"
                                                value={password}
                                                onChange={(e) => setPassword(e.target.value)}
                                            />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div className="padding_medium"></div>
                            <div className="horizontal-stack submit_panel">
                                <div className="padding_auto"></div>
                                <button id="sign_in_submit_button" onClick={() => { toggleDropdown(); login(); }}>SIGN IN</button>
                                <div className="padding_medium"></div>
                                <button id="sign_up_submit_button" onClick={() => { toggleDropdown(); createAccount(); }}>SIGN UP</button>
                            </div>
                        </div>
                    )}
                </>
            ) : (
                <>
                    <p>{activeUsername}</p>
                    <button id="sign_out_button" onClick={signOut}>SIGN OUT</button>
                </>
            )}
        </div>
    );
};