import React, {useState} from "react";
import { UpdateSessionCallback } from "./callback.js";
import "./signin.css"

export const SignIn = ({}) => {
    const [showDropdown, setShowDropdown] = useState(false);
    const [loggedIn, setLoggedIn] = useState(false);
    const [activeUsername, setActiveUsername] = useState(undefined);
    const [sessionToken, setSessionToken] = useState(undefined);

    // log the user in
    const login = async (username, password) => {
        try {
            const response = await fetch('/session', {
                method: 'POST',
                headers: { 
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    user: {
                        email: username,
                        password: password
                    }
                })
            });
        
            if (response.ok) {
                const login_res = await response.json();
                setLoggedIn(true);
                setActiveUsername(username);
                UpdateSessionCallback.trigger(login_res.session_token);
                setSessionToken(login_res.session_token);
            } else {
                throw new Error(`Failed to log in. Response status: ${response.status}`);
            }
        } catch (error) {
            console.error("Error during sign in:", error);
        }
    }
    
    // create an account for the user
    const createAccount = async (username, password) => {
        try {
            const response = await fetch('/users', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    user: {
                        email: username,
                        password: password
                    }
                })
            });
        
            if (response.ok) {
                const login_res = await response.json();
                setLoggedIn(true);
                setActiveUsername(username);
                UpdateSessionCallback.trigger(login_res.session_token);
                setSessionToken(login_res.session_token);
            } else {
                throw new Error(`Failed to create account. Response status: ${response.status}`);
            }
        } catch (error) {
            console.error("Error during create account:", error);
        }
    }
    
    // sign the user out
    const signOut = async () => {
        try {
            const response = await fetch('/session', {
                method: 'DELETE',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });
        
            if (response.ok) {
                const logout_res = await response.json();
                if (logout_res.sucess){
                    setLoggedIn(false);
                    setActiveUsername(undefined);
                    UpdateSessionCallback.trigger(undefined);
                    setSessionToken(undefined);
                }
            } else {
                throw new Error(`Failed to log out. Response status: ${response.status}`);
            }
        } catch (error) {
            console.error("Error during sign out:", error);
        }
        if (signin_sucess){
            setLoggedIn(false);
            setActiveUsername(undefined);
            UpdateSessionCallback.trigger(undefined);
            setSessionToken(undefined);
        }
    }

    // toggle the sign in box
    const toggleDropdown = () => {
        setShowDropdown(!showDropdown);
    };

    return (
        <div>
            {!loggedIn ? (
                <>
                <button id="sign_in_button" onClick={toggleDropdown}>SIGN IN</button>
                {showDropdown ? (
                    <div className="signin_dropdown">
                        <table className="username_password_table">
                        <tbody>
                            <tr>
                                <td>Username:</td>
                                <td>
                                    <input type="text" className="username_input_box" name="username" autoComplete="username"></input>
                                </td>
                            </tr>
                            <tr>
                                <td>Password (min 6 characters):</td>
                                <td>
                                    <input type="password" className="password_input_box" name="password" minLength="6" autoComplete="current-password new-password"></input>
                                </td>
                            </tr>
                        </tbody>
                        </table>
                        <div className="padding_medium"></div>
                        <div className="horizontal-stack submit_panel">
                            <div className="padding_auto"></div>
                            <button id="sign_up_submit_button" onClick={() => {
                                const username = document.querySelector(".username_input_box").value;
                                const password = document.querySelector(".password_input_box").value;
                                if (username.length >= 1 && username.length < 100 && password.length >= 6 && password.length < 100){
                                    toggleDropdown(); 
                                    login(username, password);
                                }
                            }}>SIGN UP</button>
                            <div className="padding_medium"></div>
                            <button id="sign_in_submit_button" onClick={() => {
                                const username = document.querySelector(".username_input_box").value;
                                const password = document.querySelector(".password_input_box").value;
                                if (username.length >= 1 && username.length < 100 && password.length >= 6 && password.length < 100){
                                    toggleDropdown(); 
                                    createAccount(username, password);
                                }
                            }}>SIGN IN</button>
                        </div>
                    </div>
                ) : (<></>)}
                </>
            ) : (
                <>
                <p>{activeUsername}</p>
                <button id="sign_out_button" onClick={signOut()}>SIGN OUT</button>
                </>
            )}
        </div>
    );
};