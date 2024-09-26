import React from "react";
import { Plus, Minus } from "./icons.jsx";
import "./course_panel.css"

// Component to render each item
const Course = ({
  dept,
  number,
  title,
  description,
  requisite_description,
  short_description,
  credits,
  instructors,
  campuses,
  delivery_methods,
  sections,
  requisites,
  grade,
}) => {
  return (
    <div className="course_item">
      <div className="horizontal-stack">
        <h3>
          {dept}
          {number}: {title}
        </h3>
        <button
          className="course_add_button course_add_remove_button"
          onclick="add_class()"
        >
          <Plus />
        </button>
        <button
          className="course_remove_button course_add_remove_button"
          onclick="remove_class()"
        >
          <Minus />
        </button>
      </div>
      <h3>Description:</h3>
      <p>{description}</p>

      <h3>Credits:</h3>
      <p>{credits}</p>

      {typeof grade !== `undefined` ? (
        <>
          <h3>Grade:</h3>
          <p>{grade}</p>
        </>
      ) : (
        <></>
      )}

      <h3>Prerequisites:</h3>
      <p>{requisite_description}</p>

      <h3>Sections:</h3>
      <div className="horizontal-stack">
        {sections.map((section) => (
          <>
            <p className="course_info_item">{section}</p>
            <div className="padding_medium"></div>
          </>
        ))}
      </div>

      <h3>Instructors:</h3>
      <div className="horizontal-stack">
        {instructors.map((instructor) => (
          <>
            <p className="course_info_item">{instructor}</p>
            <div className="padding_medium"></div>
          </>
        ))}
      </div>

      <h3>Campuses:</h3>
      <div className="horizontal-stack">
        {campuses.map((campus) => (
          <>
            <p className="course_info_item">{campus}</p>
            <div className="padding_medium"></div>
          </>
        ))}
      </div>
    </div>
  );
};

export { Course };
