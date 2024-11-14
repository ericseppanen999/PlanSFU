import React, { useState, useEffect } from "react";
import { Course } from "./course_panel.jsx";
import "./course_display.css";
import { fetchCourses } from "./searchCourses.js";
import { updateCourseListCallback, SearchFailCallback } from "./callback.js";
import { InfoPopup } from "./info_popup.jsx";

// the component used to display the course search results
const CourseSearchDisplay = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [search_error, setError] = useState(undefined);

  // updates the course list whenever a new result is recieved
  useEffect(() => {
    updateCourseListCallback.subscribe((courses) => {
      setCourses(courses);
      setError(undefined);
    });
  }, []);

  useEffect(() => {
    SearchFailCallback.subscribe((message) => {
      setError(message);
    });
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
    <div>
      <div className="horizontal-stack">
        <h3>Courses meeting your search:</h3>
        <div className="padding_medium"></div>
        <InfoPopup>Results may not match your prerequistes. Check with the offical course pages when planning your schedule.</InfoPopup>
      </div>
      <div className="course-list scroll">
        <div className="padding_medium"></div>
        {/* Display loading graphics */}
        {loading ? (
          <div className="center-content">
            <img className="loading_img" src="assets/loading.gif"></img>
          </div>
        ) : (
          <></>
        )}

        {/* Display error messages */}
        {search_error && (
          <p className="error_text">{search_error}</p>
        )}

        {courses.length === 0 ? <p>No results.</p> : <></>}

        <div className="course_search_result_wrapper">
          {/* Render all courses */}
          {courses.map((course) => (
            <Course
              key={course.unique_identifier}
              course={course}
              operation="add"
              makeActive={() => {}}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

// the component used to list courses in the term tabs
const CourseTermDisplay = ({ courses, visible }) => {
  const [activeCourse, setActiveCourse] = useState(undefined);

  return (
    visible && (
      <div className="term-course-list scroll">
        <div className="padding_medium"></div>
        {courses.length === 0 ? (
          <p>No courses entered for this term.</p>
        ) : (
          <></>
        )}

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
    )
  );
};

export { CourseSearchDisplay, CourseTermDisplay };
