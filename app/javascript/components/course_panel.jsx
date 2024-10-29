import React, {useCallback, useState} from "react";
import { Plus, Minus } from "./icons.jsx";
import { AddCourseCallback, RemoveCourseCallback } from "./callback.js"
import "./course_panel.css"

// Component to render each course item
const Course = ({
  course,
  operation = "add",
  minimized = false,
  showGrade = false,
  makeActive
}) => {
  // used for comunication with the tab display
  const AddCourseWrapper = useCallback(() => {
    AddCourseCallback.trigger(course);
  })

  const RemoveCourseWrapper = useCallback(() => {
    RemoveCourseCallback.trigger(course);
  })

  return (
    <div className="course_item active_panel" onClick={() => makeActive(course.unique_identifier)}>
      <div className="horizontal-stack">
        {/* title */}
        <h3>
          {course.dept.toUpperCase()} {course.number}: {course.title}
        </h3>
        {/* add or remove button */}
        {
          operation == "add" ? (
            <button
              className="flat course_add_remove_button"
              onClick={AddCourseWrapper}
            >
              <Plus />
            </button>
          ) : operation =="remove" ? (
            <button
              className="flat course_add_remove_button"
              onClick={RemoveCourseWrapper}
            >
              <Minus />
            </button>
          ) : (
            <></>
          )
        }
      </div>

      {/* description, switches depending on if it's minimized */}
      {!minimized ? (
        <>
          <p>{course.term}, {course.year}</p>

          <h3>Description:</h3>
          <p>{course.description}</p>
        </>
      ) : (
        <>
          <h3>Overview:</h3>
          <p>{course.short_description}</p>
        </>
      )}

      {/* credits */}
      <div className="horizontal-stack">
        <h3 className="course_info_item">Credits:</h3>
        <div className="padding_small"></div>
        <p className="course_info_item">{course.credits}</p>
      </div>

      {/* grade */}
      {showGrade ? (
        <>
          <h3>Grade:</h3>
          <p>{course.grade}</p>
        </>
      ) : (
        <></>
      )}

      {/* sections, preqs, instructors, campuses */}
      {!minimized ? (
        <>
          <h3>Prerequisites:</h3>
          <p>{course.requisite_description}</p>

          <h3>Sections:</h3>
          <div className="horizontal-stack">
            {course.sections.map((section, index) => (
              console.log("Section",section),
              <div key={index} className="horizontal-stack">
                <a 
                  href={`https://www.sfu.ca/outlines.html?${course.year}/${course.term}/${course.dept}/${course.number}/${section}`}
                  className="course_info_item"
                  target="_blank" 
                  rel="noopener noreferrer"
                >
                  {section}
                </a>
                <div className="padding_medium"></div>
              </div>
            ))}
          </div>

          <h3>Instructors:</h3>
          <div className="horizontal-stack">
            {course.instructors.map((instructor, index) => (
              <div key={index} className="horizontal-stack">
                <p className="course_info_item">{instructor}</p>
                <div className="padding_medium"></div>
              </div>
            ))}
          </div>

          <h3>Campuses:</h3>
          <div className="horizontal-stack">
            {course.campuses.map((campus, index) => (
              <div key={index} className="horizontal-stack">
                <p className="course_info_item">{campus}</p>
                <div className="padding_medium"></div>
              </div>
            ))}
          </div>
        </>
      ) : (<></>)}
    </div>
  );
};

export { Course };
