import { getSessionToken } from "./authentification.js";
import { UpdateTermsCallback } from "./callback.js";

const fetchTerms = async (setTerms, setActiveTerm, setLoading) => {
    setLoading(true);
    try {
        const sessionToken = getSessionToken();
        if (!sessionToken) throw new Error("user is not logged in");

        const response = await fetch("/api/user/taken_courses", {
            headers: { Authorization: `Bearer ${sessionToken}` },
        });

        if (!response.ok) throw new Error("failed to fetch taken courses");

        const takenCourses = await response.json();

        const uuids = takenCourses.map((entry) => entry.unique_identifier);
        const detailsResponse = await fetch("/api/fetch_courses", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ uuids }),
        });

        if (!detailsResponse.ok) throw new Error("failed to fetch detailed courses");

        const detailedCourses = await detailsResponse.json();

        const enrichedCourses = detailedCourses.map((course) => {
            const matchingTakenCourse = takenCourses.find(
                (entry) => entry.unique_identifier === course.unique_identifier
            );
            return { ...course, grade: matchingTakenCourse.grade || "C-" };
        });

        const termsData = enrichedCourses.reduce((acc, course) => {
            const termId = `${course.term} ${course.year}`;
            if (!acc[termId]) {
                acc[termId] = { id: termId, courses: [] };
            }
            acc[termId].courses.push(course);
            return acc;
        }, {});

        const newTerms = Object.values(termsData);
        setTerms(newTerms);
        if (newTerms.length > 0) setActiveTerm(newTerms[0].id);
        UpdateTermsCallback.trigger(newTerms);
    } catch (error) {
        if (error.message === "user is not logged in") {
            console.warn("user is not logged in");
        } else {
            console.error("error fetching terms:", error);
        }
        setTerms([]);
    }
    setLoading(false);
};

export default fetchTerms;