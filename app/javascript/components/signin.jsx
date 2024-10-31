import React, {useState} from "react";
import "./signin.css"
export const SignIn = ({}) => {
    const [showDropdown, setShowDropdown] = useState(false);
    const [loggedIn, setLoggedIn] = useState(false);
    const [activeUsername, setActiveUsername] = useState(undefined);
    const [sessionToken, setSessionToken] = useState(undefined);

    const login = (username, password) => {
        // send login request (returns session token if successful)
        // fails if username doesn't exist or if server fails to respond
        // update loggedIn, activeUsername, and sessionToken if successful
        if (signin_sucess){
            setLoggedIn(true);
            setActiveUsername(username);
            setSessionToken(new_session_token);
        }
    }
    
    const createAccount = (username, password) => {
        // send create account request (returns session token if successful)
        // fails if username already exists or if server fails to respond
        // update loggedIn, activeUsername, and sessionToken if successful
    }
    
    const signOut = () => {
        // send sign out request (clears session token on server)
        // if server responds with successful logout, reset loggedIn, activeUsername, and sessionToken
    }

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
                                    <input type="text" name="username" autoComplete="username"></input>
                                </td>
                            </tr>
                            <tr>
                                <td>Password (min 6 characters):</td>
                                <td>
                                    <input type="password" name="password" minLength="6" autoComplete="current-password new-password"></input>
                                </td>
                            </tr>
                        </tbody>
                        </table>
                        <div className="padding_medium"></div>
                        <div className="horizontal-stack submit_panel">
                            <div className="padding_auto"></div>
                            <button id="sign_up_submit_button" onClick={() => {toggleDropdown(); login(username, password);}}>SIGN UP</button>
                            <div className="padding_medium"></div>
                            <button id="sign_in_submit_button" onClick={() => {toggleDropdown(); createAccount(username, password);}}>SIGN IN</button>
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