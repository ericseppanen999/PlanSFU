import React, { useState } from "react";
import { UpdateSessionCallback } from "./callback.js";
import "./signin.css";

export const SignIn = () => {
    const [loggedIn, setLoggedIn] = useState(false);
    const [activeUsername, setActiveUsername] = useState(undefined);
    const [sessionToken, setSessionToken] = useState(undefined);
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");

    // Function to get the CSRF token
    const getCSRFToken = () => document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    // Login function
    const login = () => {
        setError("");
        fetch('/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': getCSRFToken()
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
                    setError("Invalid username or password");
                }
            })
            .catch(error => {
                console.error("Login error:", error);
                setError("An error occurred. Please try again.");
            });
    };

    // Create account function
    const createAccount = () => {
        window.location.href = "/registration";
    };

    // Sign out function
    const signOut = () => {
        fetch('/logout', {
            method: 'DELETE',
            headers: {
                'X-CSRF-Token': getCSRFToken()
            }
        })
            .then(response => {
                if (response.ok) {
                    setLoggedIn(false);
                    setActiveUsername(undefined);
                    UpdateSessionCallback.trigger(undefined);
                    setSessionToken(undefined);
                }
            })
            .catch(error => console.error("Logout error:", error));
    };

    return (
        <div>
            {!loggedIn ? (
                <div>
                    {/* Form for signing in */}
                    <input
                        type="email"
                        placeholder="Enter your email"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                    />
                    <input
                        type="password"
                        placeholder="Enter your password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                    {error && <p className="error">{error}</p>} {/* Display error message */}
                    <button id="sign_in_button" onClick={login}>SIGN IN</button>
                    <button id="sign_up_button" onClick={createAccount}>SIGN UP</button>
                </div>
            ) : (
                <div>
                    <p>Welcome, {activeUsername}</p>
                    <button className="small" onClick={signOut}>SIGN OUT</button>
                </div>
            )}
        </div>
    );
};
