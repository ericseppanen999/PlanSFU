// signin.jsx
import React, { useState, useEffect } from 'react';
import { login, logout, signup } from './authentification';
import "./signin.css";
import { FoldingPanel } from './folding_panel';
import { UserChangeCallback } from './callback';

export const SignIn = () => {
    const { loggedIn, setLoggedIn } = useState(false);
    const [error, setError] = useState(false);
    const [username, setUsername] = useState(undefined);
    const [showDropdown, setShowDropdown] = useState(false);

    useEffect(() => {
        UserChangeCallback.subscribe((user) => {
          setLoggedIn(user.sessionToken != undefined);
          setUsername(user.username);
        })
    }, [])

    const handleSignOut = async () => {
        if (logout() != 0) {
            setError(true);
        }
    };

    const handleSignUp = async () => {
        const newusername = document.getElementById("username_input_box").value;
        const newpassword = document.getElementById("password_input_box").value;
        if (signup(newusername, newpassword) != 0) {
            setError(true);
        }
    };

    const handleSignIn = async () => {
        const tryusername = document.getElementById("username_input_box").value;
        const trypassword = document.getElementById("password_input_box").value;
        if (login(tryusername, trypassword) != 0) {
            setError(true);
        }
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
                                                required
                                            />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div className="padding_medium"></div>
                            <div className="horizontal-stack submit_panel">
                                {error && (
                                    <p className="error_text">this is an error</p>
                                )}
                                <div className="padding_auto"></div>
                                <button className="small" type="submit" id="sign_in_submit_button" name="sign_in_submit_button" onClick={handleSignIn}>SIGN IN</button>
                                <div className="padding_medium"></div>
                                <button className="small" type="button" id="sign_up_submit_button" name="sign_up_submit_button" onClick={handleSignUp}>SIGN UP</button>
                            </div>
                        </form>
                    </FoldingPanel>
                </>
            ) : (
                <>
                    <div className="horizontal-stack">
                        <p>{username}</p>
                        <div className="padding_medium"></div>
                        <div className="center-content">
                            <button className="small" id="sign_out_button" name="sign_out_button" onClick={handleSignOut}>SIGN OUT</button>
                        </div>
                    </div>
                    {error && (
                        <p className="error_text">{error}</p>
                    )}
                </>
            )}
        </div>
    );
};