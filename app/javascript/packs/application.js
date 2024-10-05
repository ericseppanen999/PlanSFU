import React from "react";
import { CourseSearchDisplay } from "../components/course_display.jsx"
import { TermTabDisplay } from "../components/term_tab.jsx"
import { createRoot } from 'react-dom/client';

const tabDisplayRenderer = createRoot(document.getElementById('term_tab_display'));
tabDisplayRenderer.render(<TermTabDisplay />);

const searchDisplayRenderer = createRoot(document.getElementById('course_search_display'));
searchDisplayRenderer.render(<CourseSearchDisplay />);

