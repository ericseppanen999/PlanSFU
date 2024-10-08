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
      let query = ``;
      const response = await fetch(`/courses/search?searchstring=${encodeURIComponent(query)}&term=${encodeURIComponent(`fall`)}&year=${encodeURIComponent(`2024`)}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });
      if (response.ok) {
        let search_res = await response.json();
        console.log(`response data: ${JSON.stringify(search_res, undefined, 4)}`);
        setCourses(search_res);
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
                <Course key={course.unique_identifier} course={course} operation="add" makeActive={() => {}}/>
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
                <Course key={course.unique_identifier} course={course} operation="remove" minimized={activeCourse !== course.unique_identifier} showGrade={true} makeActive={(unique_identifier) => setActiveCourse(unique_identifier)}/>
            ))}
        </div>
    </div>
  );
};

export { CourseSearchDisplay, CourseTermDisplay };
