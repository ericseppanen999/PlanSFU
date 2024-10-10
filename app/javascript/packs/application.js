// this is the react / js entrypoint for the main page

import React from "react"

import { fetchCourses } from "../components/searchCourses.js"
import { changeQueryCallback, updateCouseListCallback } from "../components/callback.js"
// import react components
import { CourseSearchDisplay } from "../components/course_display.jsx"
import { TermTabDisplay } from "../components/term_tab.jsx"
import { createRoot } from 'react-dom/client'
import { SearchBarWithDropdown } from "../components/search_bar_and_dropdown.jsx"

// setup query change callback

changeQueryCallback.subscribe((query) => {
    fetchCourses(updateCouseListCallback.trigger, query);
})

// add react elements to index.html

const tabDisplayRenderer = createRoot(document.getElementById('term_tab_display'));
tabDisplayRenderer.render(<TermTabDisplay />);

const searchDisplayRenderer = createRoot(document.getElementById('course_search_display'));
searchDisplayRenderer.render(<CourseSearchDisplay />);

const searchBarDropdownRenderer = createRoot(document.getElementById('searchbar_and_dropdown_display'));
searchBarDropdownRenderer.render(<SearchBarWithDropdown />);
