import React, {useState} from "react";
import { UpdateSessionCallback } from "./callback.js";
import { FoldingPanel } from "./folding_panel.jsx";
import "./signin.css"

export const SignIn = () => {
    const [showDropdown, setShowDropdown] = useState(false);
    const [loggedIn, setLoggedIn] = useState(false);
    const [activeUsername, setActiveUsername] = useState(undefined);
    const [sessionToken, setSessionToken] = useState(undefined);
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [showBadCredError, setBadCredError] = useState(false);
    const [showSigninError, setSigninError] = useState(false);
    const [showSignupError, setSignupError] = useState(false);
    const [showSignoutError, setSignoutError] = useState(false);

    const resetErrors = () => {
        setBadCredError(false);
        setSigninError(false);
        setSignoutError(false);
        setSignupError(false);
    }

    const login = () => {
        resetErrors();
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
                    setShowDropdown(false);
                } else {
                    setSigninError(true);
                }
            })
            .catch(error => console.error("Login error:", error));
    };

    const createAccount = () => {
        resetErrors();
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
                    setShowDropdown(false);
                } else {
                    setSignupError(true);
                }
            })
            .catch(error => console.error("Account creation error:", error));
    };

    const signOut = () => {
        resetErrors();
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
                    setSignoutError(true);
                }
            })
            .catch(error => console.error("Logout error:", error));
    };

    return (
        <div>
            {!loggedIn ? (
                <>
                    <button id="sign_in_button" onClick={() => setShowDropdown(true)}>SIGN IN</button>
                    <FoldingPanel className="signin_dropdown" is_open={showDropdown} set_open_callback={setShowDropdown}>
                        <form>
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
                                                required
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
                                <button className="small" type="submit" id="sign_in_submit_button" onClick={login}>SIGN IN</button>
                                <div className="padding_medium"></div>
                                <button className="small" type="submit" id="sign_up_submit_button" onClick={createAccount}>SIGN UP</button>
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
                            <button className="small" id="sign_out_button" onClick={signOut}>SIGN OUT</button>
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