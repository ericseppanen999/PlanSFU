import React, { useState } from "react";
import { UpdateSessionCallback } from "./callback.js";
import { FoldingPanel } from "./folding_panel.jsx";
import "./signin.css"

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
                <>
                    <button id="sign_in_button" name="sign_in_button" onClick={() => setShowDropdown(true)}>SIGN IN</button>
                    <FoldingPanel className="signin_dropdown" is_open={showDropdown} set_open_callback={setShowDropdown}>
                        <form>
                            <table className="username_password_table">
                                <tbody>
                                    <tr>
                                        <td><label htmlFor="username_input_box">Username:</label></td>
                                        <td>
                                            <input
                                                type="text"
                                                id="username_input_box"
                                                name="username"
                                                autoComplete="username"
                                                value={username}
                                                onChange={(e) => setUsername(e.target.value)}
                                                required
                                            />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label htmlFor="password_input_box">Password (min 6 characters):</label></td>
                                        <td>
                                            <input
                                                type="password"
                                                name="password"
                                                minLength="6"
                                                id="password_input_box"
                                                autoComplete="current-password new-password"
                                                value={password}
                                                onChange={(e) => setPassword(e.target.value)}
                                                required
                                            />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div className="padding_medium"></div>
                            <div className="horizontal-stack submit_panel">
                                {showBadCredError && (
                                    <>
                                        <p className="error_text">Invalid username / password combo</p>
                                    </>
                                )}
                                {showSigninError && (
                                    <>
                                        <p className="error_text">Failed to sign in</p>
                                    </>
                                )}
                                {showSignupError && (
                                    <>
                                        <p className="error_text">Failed to sign up</p>
                                    </>
                                )}
                                <div className="padding_auto"></div>
                                <button className="small" type="submit" id="sign_in_submit_button" name="sign_in_submit_button" onClick={login}>SIGN IN</button>
                                <div className="padding_medium"></div>
                                <button className="small" type="submit" id="sign_up_submit_button" name="sign_up_submit_button" onClick={createAccount}>SIGN UP</button>
                            </div>
                        </form>
                    </FoldingPanel>
                </>
            ) : (
                <>
                    <div className="horizontal-stack">
                        <p>{activeUsername}</p>
                        <div className="padding_medium"></div>
                        <div className="center-content">
                            <button className="small" id="sign_out_button" name="sign_out_button" onClick={signOut}>SIGN OUT</button>
                        </div>
                    </div>
                    {showSignoutError && (
                        <>
                            <p className="error_text">Failed to sign out</p>
                        </>
                    )}
                </>
            )}
        </div>
    );
};
