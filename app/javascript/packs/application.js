import React from "react";
import { CourseSearchDisplay } from "../components/course_display.jsx"
import { createRoot } from 'react-dom/client';


const root = createRoot(document.getElementById('course_search_display'));
root.render(<CourseSearchDisplay />);