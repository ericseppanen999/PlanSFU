import React, { useState, useEffect } from "react";
import { Course } from "./course_panel.jsx"
import "./course_display.css"

// Parent component to render the list of items
const CourseSearchDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchCourses = async () => {
      console.log("ran");
      setLoading(true);
      let query = `hello world`;
      const response = await fetch(`courses?searchquery=${query}`);
      if (response.ok) {
        //console.log(`response data: ${JSON.stringify(search_res.message, undefined, 4)}`);
        let search_res = await response.json();
        setCourses(search_res.message);
      } else {
        throw new Error(
          `Failed to fetch search result. Response status: ${response.status}`
        );
      }
      setLoading(true);
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

      <div>
        {courses.map((course) => (
          <Course key={course.courseid} {...course} />
        ))}
      </div>
    </div>
  );
};

export { CourseSearchDisplay };
