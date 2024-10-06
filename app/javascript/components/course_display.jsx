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
      const response = await fetch(`/courses/search?searchstring=${query}`);
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
                <Course key={course.courseid} course={course} operation="add" makeActive={() => {}}/>
            ))}
        </div>
    </div>
  );
};

const CourseTermDisplay = ({courses}) => {
  const [activeCourse, setActiveCourse] = useState(undefined);

  return (
    <div>
        {courses.length === 0 ? 
            <p>No courses entered for this term.</p>
       : <></>}

        <div>
            {courses.map((course) => (
                <Course key={course.id} course={course} operation="remove" minimized={activeCourse === course.id} showGrade={true} makeActive={(courseid) => setActiveCourse(courseid)}/>
            ))}
        </div>
    </div>
  );
};

export { CourseSearchDisplay, CourseTermDisplay };
