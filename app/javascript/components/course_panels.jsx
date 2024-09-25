import { useState } from "react";
  
  // Component to render each item
  const Course = (
    {
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
      grade
    }
  ) => {
    return (
      <div class="course_item">
        <div class="horizontal-stack">
          <h3>{dept}{number}: {title}</h3>
          <button class="course_add_button course_add_remove_button" onclick="add_class()">
            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="var(--text-color)"><path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z"/></svg>
          </button>
          <button class="course_remove_button course_add_remove_button" onclick="remove_class()">
            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="var(--text-color)"><path d="M200-440v-80h560v80H200Z"/></svg>
          </button>
        </div>
        <h3>Description:</h3>
        <p>{description}</p>

        <h3>Credits:</h3>
        <p>{credits}</p>

        {(typeof grade !== 'undefined') ? (
          <>
            <h3>Grade:</h3>
            <p>{grade}</p>
          </>
        ) : ( <></> )}

        <h3>Prerequisites:</h3>
        <p>{requisite_description}</p>

        <h3>Sections:</h3>
        <div>
          {sections.map((section) => (
            <p>{section}</p>
          ))}
        </div>

        <h3>Instructors:</h3>
        <div>
          {instructors.map((instructor) => (
            <p>{instructor}</p>
          ))}
        </div>

        <h3>Campuses:</h3>
        <div>
          {campuses.map((campus) => (
            <p>{campus}</p>
          ))}
        </div>
      </div>
    );
  };
  
  // Parent component to render the list of items
  const CourseSearchDisplay = () => {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
      const fetchCourses = async () => {
        setLoading(true);
        const response = await fetch(`courses?searchquery=${query}`);
        if (response.ok) {
          //console.log(`response data: ${JSON.stringify(search_res.message, undefined, 4)}`);
          search_res = await response.json();
          setCourses(search_res.message);
        } else {
          throw new Error(`Failed to fetch search result. Response status: ${response.status}`);
        }
        setLoading(false);
      };
  
      fetchCourses();
    }, []);

    return (
      <div>
        { loading ? (
          <img src="assets/images/loading.gif"></img>
        ) : ( <></> )}
        
        {courses.items.map((course) => (
          <Course {...course} />
        ))}
      </div>
    );
  };
  
  export default { CourseSearchDisplay, Course };