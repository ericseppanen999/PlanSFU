import React from "react";
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import { createRoot } from 'react-dom/client';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import { fetchCourses } from "../components/searchCourses.js";
import { changeQueryCallback, updateCourseListCallback } from "../components/callback.js";
// import react components
import { CourseSearchDisplay } from "../components/course_display.jsx";
import { TermTabDisplay } from "../components/term_tab.jsx";
import { SearchBarWithDropdown } from "../components/search_bar_and_dropdown.jsx";
import { SignIn } from "../components/signin.jsx";
import { ExternalLinksSidebar } from "../components/external_links_sidebar.jsx";

// setup query change callback
changeQueryCallback.subscribe((query) => {
    console.log("Query updated:", query);
    fetchCourses((res) => {
        console.log("Courses fetched:", res);
        updateCourseListCallback.trigger(res);
    }, query);
});

// add react elements to index.html
const tabDisplayRenderer = createRoot(document.getElementById('term_tab_display'));
tabDisplayRenderer.render(
    <TermTabDisplay />
);

const searchDisplayRenderer = createRoot(document.getElementById('course_search_display'));
searchDisplayRenderer.render(
    <CourseSearchDisplay />
);

const searchBarDropdownRenderer = createRoot(document.getElementById('searchbar_and_dropdown_display'));
searchBarDropdownRenderer.render(
    <SearchBarWithDropdown />
);

const signInRenderer = createRoot(document.getElementById('signin_display'));
signInRenderer.render(
    <SignIn />
);

const externalLinksSidebarRenderer = createRoot(document.getElementById('external_links_sidebar_display'));
externalLinksSidebarRenderer.render(
    <ExternalLinksSidebar />
);