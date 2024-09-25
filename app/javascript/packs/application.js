import CourseSearchDisplay from "../components/course_panels.jsx"
import { createRoot } from 'react-dom/client';
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
 
Rails.start();
Turbolinks.start();
ActiveStorage.start();

const root = createRoot(document.getElementById('course_search_display'));
root.render(<CourseSearchDisplay />);