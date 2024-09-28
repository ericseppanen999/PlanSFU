import React, { useState, useEffect } from "react";
import { Course } from "./course_panel.jsx"
import "./course_display.css"

// Parent component to render the list of items
const CourseSearchDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);

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

export { CourseSearchDisplay };
