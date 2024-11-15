// signin.jsx
import React, { useState, useContext } from 'react';
import { AuthContext } from './auth';
import "./signin.css";
import { FoldingPanel } from './folding_panel';

export const SignIn = () => {
    const { login, logout, user } = useContext(AuthContext);
    const [credentials, setCredentials] = useState({
        username: '',
        password: ''
    });
    const [error, setError] = useState('');
    const [showDropdown, setShowDropdown] = useState(false);

    const getCSRFToken = () => document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');

        try {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': getCSRFToken()
                },
                body: JSON.stringify({
                    user: {
                        username: credentials.username,
                        password: credentials.password
                    }
                })
            });

            const data = await response.json();

            if (data.session_token) {
                login({
                    username: credentials.username,
                    token: data.session_token,
                    courses: data.courses || []
                });

                // Store session token in localStorage
                localStorage.setItem('session_token', data.session_token);
                localStorage.setItem('username', credentials.username);
            } else {
                setError(data.error || 'Invalid username or password');
            }
        } catch (err) {
            setError('An error occurred during sign in');
            console.error('Login error:', err);
        }
    };

    const createAccount = () => {
        window.location.href = "/registration"; // Redirect to the registration path
    };

    const handleSignOut = async () => {
        try {
            const response = await fetch('/logout', {
                method: 'DELETE',
                headers: {
                    'X-CSRF-Token': getCSRFToken()
                }
            });

            if (response.ok) {
                logout();
                localStorage.removeItem('session_token');
                localStorage.removeItem('username');
            } else {
                setError('Failed to sign out');
            }
        } catch (err) {
            setError('An error occurred during sign out');
            console.error('Sign out error:', err);
        }
    };

    return (
        <div>
            {!user ? (
                <>
                    <button id="sign_in_button" name="sign_in_button" onClick={() => setShowDropdown(true)}>SIGN IN</button>
                    <FoldingPanel className="signin_dropdown" is_open={showDropdown} set_open_callback={setShowDropdown}>
                        <form onSubmit={handleSubmit}>
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
                                                value={credentials.username}
                                                onChange={(e) => setCredentials({ ...credentials, username: e.target.value })}
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
                                                value={credentials.password}
                                                onChange={(e) => setCredentials({ ...credentials, password: e.target.value })}
                                                required
                                            />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div className="padding_medium"></div>
                            <div className="horizontal-stack submit_panel">
                                {error && (
                                    <p className="error_text">{error}</p>
                                )}
                                <div className="padding_auto"></div>
                                <button className="small" type="submit" id="sign_in_submit_button" name="sign_in_submit_button">SIGN IN</button>
                                <div className="padding_medium"></div>
                                <button className="small" type="button" id="sign_up_submit_button" name="sign_up_submit_button" onClick={createAccount}>SIGN UP</button>
                            </div>
                        </form>
                    </FoldingPanel>
                </>
            ) : (
                <>
                    <div className="horizontal-stack">
                        <p>{credentials.username}</p>
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