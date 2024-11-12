import React, { createContext, useState, useEffect } from 'react';

export const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [token, setToken] = useState(localStorage.getItem('session_token'));
    const [courses, setCourses] = useState(JSON.parse(localStorage.getItem('courses') || '[]'));

    const login = (userData, sessionToken) => {
        setUser(userData);
        setToken(sessionToken);
        if (userData.courses) {
            setCourses(userData.courses);
            localStorage.setItem('courses', JSON.stringify(userData.courses));
        }
        localStorage.setItem('session_token', sessionToken);
    };

    const logout = () => {
        setUser(null);
        setToken(null);
        setCourses([]);
        localStorage.removeItem('session_token');
        localStorage.removeItem('courses');
    };

    useEffect(() => {
        const validateToken = async () => {
            if (token) {
                try {
                    const response = await fetch('/api/auth/validate', {
                        headers: {
                            'Authorization': `Bearer ${token}`
                        }
                    });
                    if (!response.ok) {
                        logout();
                    }
                } catch (error) {
                    logout();
                }
            }
        };
        validateToken();
    }, [token]); // Add token to dependency array

    return (
        <AuthContext.Provider value={{
            user,
            token,
            courses,
            login,
            logout,
            setCourses
        }}>
            {children}
        </AuthContext.Provider>
    );
};