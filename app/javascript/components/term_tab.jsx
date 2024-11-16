import React, { useState, useEffect} from "react";
import { CourseTermDisplay } from "../components/course_display.jsx"
import { UserChangeCallback, AddCourseCallback, RemoveCourseCallback, UpdateTermsCallback , SetGradeCallback} from "./callback.js"
import "./term_tab.css"
import { getSessionToken } from "./authentification.js"
import fetchTerms from "./fetchTerms.js"
let refetchTerms = null;

const TermTabDisplay = () => {
    const [terms, setTerms] = useState([]);
    const [activeterm, setActiveTerm] = useState(0);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        refetchTerms = () => fetchTerms(setTerms, setActiveTerm, setLoading);
        refetchTerms();
    }, []);

    useEffect(() => {
        UserChangeCallback.subscribe((new_user) => {
            if (!new_user.sessionToken) {
                setTerms([]);
                setActiveTerm(0);
            }
        });
    }, []);
    
    // setup the callback for removing a course
    useEffect(() => {
        RemoveCourseCallback.subscribe((course) => {
            const id = course.term + " " + course.year;

            setTerms((currterms) => {
                const termidx = currterms.findIndex((term) => term.id === id);
                if (termidx != -1){
                    const courseidx = currterms[termidx].courses.findIndex((c) => c.unique_identifier === course.unique_identifier);
                    if (courseidx != -1){
                        let newterms = [...currterms];
                        if (newterms[termidx].courses.length === 1){
                            console.log("ran");
                            newterms.splice(termidx, 1);
                        } else {
                            newterms[termidx].courses.splice(courseidx, 1);
                        }
                        UpdateTermsCallback.trigger(newterms);
                        return newterms;
                    }
                }
                UpdateTermsCallback.trigger(currterms);
                return currterms;
            })
        }
    )}, [])

    // setup the callback for adding a course
    useEffect(() => {
        AddCourseCallback.subscribe((course) => {
            //console.log(JSON.stringify(course));
            const id = course.term + " " + course.year;

            setTerms((currterms) => {
                const idx = currterms.findIndex((term) => term.id === id);
                if (idx == -1){
                    setActiveTerm(id);
                    const newterms = [...currterms, {id:id, courses:[course]}];
                    UpdateTermsCallback.trigger(newterms);
                    return newterms;
                } else {
                    if (!currterms[idx].courses.some((c) => c.unique_identifier === course.unique_identifier)){
                        const newterms = [...currterms];
                        newterms[idx].courses.push(course);
                        UpdateTermsCallback.trigger(newterms);
                        return newterms;
                    }
                }
                UpdateTermsCallback.trigger(currterms);
                return currterms;
            })            
        }
    )}, [])

    // setup the callback for setting a course grade
    useEffect(() => {
        SetGradeCallback.subscribe((course, grade) => {
            const id = course.term + " " + course.year;

            setTerms((currterms) => {
                const termidx = currterms.findIndex((term) => term.id === id);
                if (termidx != -1){
                    const courseidx = currterms[termidx].courses.findIndex((c) => c.unique_identifier === course.unique_identifier);
                    if (courseidx != -1){
                        let newterms = [...currterms];
                        newterms[termidx].courses[courseidx].grade = grade;
                        UpdateTermsCallback.trigger(newterms);
                        return newterms;
                    }
                }
                UpdateTermsCallback.trigger(currterms);
                return currterms;
            })
        }
    )}, [])
  
    // run at startup
    {/*
    useEffect(() => {
      const fetchTerms = async () => {
        setLoading(true);
        // get content from server on login or on load
        setTerms((currterms) => {
            UpdateTermsCallback.trigger(currterms);
            return currterms;
        });
        setLoading(false);
        // needs to be able to get terms (not working bc terms is [] when this function is created)
      };
  
      fetchTerms();
    }, []);
    */}
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

            <div className="tab_header horizontal-stack">
                {terms.map((term) => (
                    <div className="term_tab_header center-content no-select" style={{borderBottom: `${term.id === activeterm ? `3px solid var(--base-color)` : `1px solid var(--base-dark)`}`}} key={term.id} onClick={() => {setActiveTerm(term.id)}}>
                        {term.id}
                    </div>
                ))}
            </div>
    
            {terms.length === 0 ? 
                <p>You have no courses selected. Add courses with the search or sign in to fill in your completed courses.</p>
            : <></>}
    
            <div>
                {terms.map((term) => (
                    <CourseTermDisplay key={term.id} courses={term.courses} visible={term.id == activeterm}/>
                ))}
            </div>
      </div>
    );
  };
export { TermTabDisplay, refetchTerms };