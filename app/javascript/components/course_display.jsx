import React, { useState, useEffect } from "react";
import { Course } from "./course_panel.jsx";
import "./course_display.css";
import { fetchCourses } from "./searchCourses.js";
import { updateCourseListCallback } from "./callback.js"

// the component used to display the course search results
const CourseSearchDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);

  // updates the course list whenever a new result is recieved
  useEffect(() => {
    updateCourseListCallback.subscribe((courses) => {
      setCourses(courses);
    })
  }, []);
  
  // Runs at startup & populates the courses
  useEffect(() => {
    const loadCourses = async () => {
      setLoading(true);
      fetchCourses(setCourses);
      setLoading(false);
    };
    
    loadCourses();
  }, []);

  return (
    <div className="course-list scroll">
      <div class="padding_medium"></div>
      {/* Display loading graphics */}
      {loading ? 
        <div className="center-content">
          <img className="loading_img" src="assets/loading.gif"></img>
        </div>
      : <></>}

      {courses.length === 0 ? 
        <p>No results.</p>
      : <></>}

      <div>
        {/* Render all courses */}
        {courses.map((course) => (
          <Course key={course.unique_identifier} course={course} operation="add" makeActive={() => {}}/>
        ))}
      </div>
    </div>
  );
};


// the component used to list courses in the term tabs
const CourseTermDisplay = ({courses, visible}) => {
  const [activeCourse, setActiveCourse] = useState(undefined);

  return (
    visible && <div className="course-list scroll">
      <div class="padding_medium"></div>
        {courses.length === 0 ? 
          <p>No courses entered for this term.</p>
        : <></>}

        <div>
          {/* Render all courses */}
          {courses.map((course) => (
            <Course 
              key={course.unique_identifier} 
              course={course} 
              operation="remove" 
              minimized={activeCourse !== course.unique_identifier} 
              showGrade={true} 
              makeActive={(unique_identifier) => setActiveCourse(unique_identifier)}
            />
          ))}
        </div>
    </div>
  );
};

export { CourseSearchDisplay, CourseTermDisplay };
