import { getSessionToken } from "./authentification";

const addCoursesToUser = async (courses) => {
    const session_token = getSessionToken();

    if (!session_token) {
        console.warn("user is not logged in"); // maybe not
        return;
    }

    try {
        const response = await fetch('/users/add_courses', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${session_token}`,
            },
            body: JSON.stringify({ courses }),
        });

        if (response.ok) {
            console.log("courses successfully added to user database.");
        } else {
            console.error("failed to add courses to user database.");
        }

    } catch (error) {
        console.error("error adding courses to user database:", error);
    }
};

export default addCoursesToUser;