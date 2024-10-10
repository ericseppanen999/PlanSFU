import React, { useState, useEffect} from "react";
import { CourseTermDisplay } from "../components/course_display.jsx"
import { AddCourseCallback, RemoveCourseCallback } from "./callback.js"
import "./term_tab.css"

const TermTabDisplay = () => {
    const [terms, setTerms] = useState([]);
    const [loading, setLoading] = useState(false);

    // setup the callback from removing a course
    useEffect(() => {
        RemoveCourseCallback.subscribe((course) => {
            const id = course.year + " " + course.term;

            setTerms((currterms) => {
                const termidx = currterms.findIndex((term) => term.id === id);
                if (termidx != -1){
                    const courseidx = currterms[termidx].courses.findIndex((c) => c.unique_identifier === course.unique_identifier);
                    if (courseidx != -1){
                        let newterms = [...currterms];
                        newterms[termidx].courses.splice(courseidx, 1);
                        return newterms;
                    }
                }
                return currterms;
            })
        }
    )}, [])

    // setup the callback for adding a course
    useEffect(() => {
        AddCourseCallback.subscribe((course) => {
            console.log(JSON.stringify(course));
            const id = course.year + " " + course.term;

            setTerms((currterms) => {
                const idx = currterms.findIndex((term) => term.id === id);
                if (idx == -1){
                    return [...currterms, {id:id, courses:[course]}];
                } else {
                    if (!currterms[idx].courses.includes(course)){
                        const newterms = [...currterms];
                        newterms[idx].courses.push(course);
                        return newterms;
                    }
                }
                return currterms;
            })            
        }
    )}, [])
  
    // run at startup or whenever the search updates
    useEffect(() => {
      const fetchTerms = async () => {
        setLoading(true);
        // get content from server on login or on load
        setLoading(false);
      };
  
      fetchTerms();
    }, []);

    // loading: grey out pane, display elipsis
    // one tab for each closed term + open term
    // if no terms, tell user to add courses
  
    return (
      <div className="tab_container">
            {loading ? 
                <div className="greyout_container">
                    <div className="loading_greyout center-content">
                        <img className="loading_img" src="assets/loading.gif"></img>
                    </div>
                </div>
            : <></>}

            <div className="tab_header">
                {terms.map((term) => (
                    <div className="term_tab_header center-content" key={term.id}>
                        {term.id}
                    </div>
                ))}
            </div>
    
            {terms.length === 0 ? 
                <p>You have no courses listed. Add courses with the search or sign in to fill in your completed courses.</p>
            : <></>}
    
            <div className="scroll">
                {terms.map((term) => (
                    <CourseTermDisplay key={term.id} courses={term.courses} operation="remove"/>
                ))}
            </div>
      </div>
    );
  };

export { TermTabDisplay };