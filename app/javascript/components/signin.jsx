// app/javascript/components/SignIn.jsx
import React, { useState, useContext } from 'react';
import { AuthContext } from './auth';
import "./signin.css";

export const SignIn = () => {
    const { login } = useContext(AuthContext);
    const [credentials, setCredentials] = useState({
        username: '',
        password: ''
    });
    const [error, setError] = useState('');

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

    return (
        <div className="signin_dropdown">
            <form onSubmit={handleSubmit}>
                <table className="username_password_table">
                    <tbody>
                        <tr>
                            <td>
                                <input
                                    type="text"
                                    value={credentials.username}
                                    onChange={(e) => setCredentials({
                                        ...credentials,
                                        username: e.target.value
                                    })}
                                    placeholder="Username"
                                    required
                                />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input
                                    type="password"
                                    value={credentials.password}
                                    onChange={(e) => setCredentials({
                                        ...credentials,
                                        password: e.target.value
                                    })}
                                    placeholder="Password"
                                    required
                                />
                            </td>
                        </tr>
                    </tbody>
                </table>
                {error && <div className="error_text">{error}</div>}
                <div className="submit_panel">
                    <button type="submit">Sign In</button>
                    <button type="button" onClick={createAccount}>Sign Up</button>
                </div>
            </form>
        </div>
    );
};