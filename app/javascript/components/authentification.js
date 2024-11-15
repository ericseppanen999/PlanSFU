import { UserChangeCallback } from './callback';

const user = {username:undefined, sessionToken:undefined, grades:[], courses:[]};

UserChangeCallback.subscribe((new_user) => {
    user = new_user;
});

export const login = (username, password) => {
    // check if user is already logged in
    if (!user.sessionToken){
        // check username-password combo with server
        // add code here
        if (login_success){
            UserChangeCallback.trigger({username:username, sessionToken:newSessionToken, grades:usergrades, courses:usercourses});
            return 0; // no errors
        } else {
            if (bad_creds){
                return 1; // error flag for invalid username-password combo
            } else {
                return 2; // error flag for unknown failure
            }
        }
    } else {
        return 3; // error flag for user already logged in
    }
}

export const signup = (username, password) => {
    // check if user is already logged in
    if (!user.sessionToken){
        // check username-password combo with server
        // add code here
        if (signup_success){
            UserChangeCallback.trigger({username:username, sessionToken:newSessionToken, grades:[], courses:[]});
            return 0; // no errors
        } else {
            if (already_exists){
                return 1; // error flag for username already exists
            } else {
                return 2; // error flag for unknown failure
            }
        }
    } else {
        return 3; // error flag for user already logged in
    }
}

export const logout = () => {
    // check if user is logged in
    if (user.sessionToken){
        // send logout request to server
        // add code here
        if (logout_success){
            UserChangeCallback.trigger({username:undefined, sessionToken:undefined, grades:[], courses:[]});
            return 0; // no errors
        } else {
            return 1; // error
        }
    }
}

/*
export const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [token, setToken] = useState(localStorage.getItem('session_token'));
    const [courses, setCourses] = useState(JSON.parse(localStorage.getItem('courses') || '[]'));

    const login = (userData, sessionToken) => {
        UserChangeCallback.trigger(({username, sessionToken}))
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
*/