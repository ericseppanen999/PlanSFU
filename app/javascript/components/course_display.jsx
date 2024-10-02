import React, { useState, useEffect } from "react";
import { Course } from "./course_panel.jsx"
import "./course_display.css"

const CourseSearchDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);

  // run at startup or whenever the search updates
  useEffect(() => {
    const fetchCourses = async () => {
      setLoading(true);
      let query = `hello world`;
      const response = await fetch(`courses?searchquery=${query}`);
      if (response.ok) {
        let search_res = await response.json();
        console.log(`response data: ${JSON.stringify(search_res.message, undefined, 4)}`);
        setCourses(search_res.message);
      } else {
        throw new Error(
          `Failed to fetch search result. Response status: ${response.status}`
        );
      }
      setLoading(false);
    };

    fetchCourses();
  }, []);

  return (
    <div>
        {loading ? 
            <div className="center-content">
                <img className="loading_img" src="assets/loading.gif"></img>
            </div>
       : <></>}

        {courses.length === 0 ? 
            <p>No results.</p>
       : <></>}

        <div>
            {courses.map((course) => (
                <Course key={course.courseid} {...course} />
            ))}
        </div>
    </div>
  );
};

const CourseTermDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);

  // run at startup
  useEffect(() => {
    const fetchCourses = async () => {
      setLoading(true);
      // get term info from cookie, then query server for info, or just query server if user logged in
      setLoading(false);
    };

    fetchCourses();
  }, []);

  return (
    <div>
        {loading ? 
            <div className="center-content">
                <img className="loading_img" src="assets/loading.gif"></img>
            </div>
       : <></>}

        {courses.length === 0 ? 
            <p>No courses entered for this term.</p>
       : <></>}

        <div>
            {courses.map((course) => (
                <Course key={course.courseid} {...course} />
            ))}
        </div>
    </div>
  );
};

export { CourseSearchDisplay, CourseTermDisplay };
