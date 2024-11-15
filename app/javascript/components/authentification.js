import { UserChangeCallback } from './callback';

let user = { username: undefined, sessionToken: undefined, grades: [], courses: [] };

UserChangeCallback.subscribe((new_user) => {
    user = new_user;
});

export const login = async (username, password) => {
    // check if user is already logged in
    if (!user.sessionToken) {
        try {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, password })
            });

            if (response.ok) {
                const data = await response.json();
                UserChangeCallback.trigger({ username: data.user.username, sessionToken: data.session_token, grades: data.grades, courses: data.courses });
                return 0; // no errors
            } else {
                if (response.status === 401) {
                    return 1; // error flag for invalid username-password combo
                } else {
                    return 2; // error flag for unknown failure
                }
            }
        } catch (error) {
            console.error('Login error:', error);
            return 2; // error flag for unknown failure
        }
    } else {
        return 3; // error flag for user already logged in
    }
};

export const signup = async (username, password) => {
    // check if user is already logged in
    if (!user.sessionToken) {
        try {
            const response = await fetch('/api/auth/signup', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, password })
            });

            if (response.ok) {
                const data = await response.json();
                UserChangeCallback.trigger({ username: data.user.username, sessionToken: data.session_token, grades: [], courses: [] });
                return 0; // no errors
            } else {
                if (response.status === 409) {
                    return 1; // error flag for username already exists
                } else {
                    return 2; // error flag for unknown failure
                }
            }
        } catch (error) {
            console.error('Signup error:', error);
            return 2; // error flag for unknown failure
        }
    } else {
        return 3; // error flag for user already logged in
    }
};

export const logout = async () => {
    // check if user is logged in
    if (user.sessionToken) {
        try {
            const response = await fetch('/api/auth/logout', {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${user.sessionToken}`
                }
            });

            if (response.ok) {
                UserChangeCallback.trigger({ username: undefined, sessionToken: undefined, grades: [], courses: [] });
                return 0; // no errors
            } else {
                return 1; // error
            }
        } catch (error) {
            console.error('Logout error:', error);
            return 1; // error
        }
    }
    return 1; // error if no session token
};