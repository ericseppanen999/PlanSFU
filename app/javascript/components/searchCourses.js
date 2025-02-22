import { SearchFailCallback } from "./callback";
import { getSessionToken } from "./authentification";
import addCoursesToUser from "./addCoursesToUser";

// the default 
export const defaultQuery = {
  searchstring: "",
  search_in_props: ["title", "description", "year", "term"],
  terms: [{ year: "any", term: "any" }],
  departments: ["any"],
  levels: ["any"],
  SQL: "",
  courses: [],
  use_courses: false,
};


// returns a course list to successCallback if courses are successfully fetched, given a search query
export const fetchCourses = async (successCallback, searchparams = defaultQuery) => {

  //console.log("checking course fetch...");
  //session_token = getSessionToken();
  // console.log(`session_token: ${user.session_token}`);
  const session_token = getSessionToken();

  const queryParams = new URLSearchParams();
  queryParams.append("searchstring", searchparams.searchstring);
  searchparams.search_in_props.forEach(prop => queryParams.append('search_in_props[]', prop));

  searchparams.terms.forEach((term) => {
    queryParams.append('terms[][year]', term.year);
    queryParams.append('terms[][term]', term.term);
  });

  if (searchparams.departments && searchparams.departments.length === 0) {
    queryParams.append('departments[]', 'none');
  } else if (searchparams.departments[0] !== "any") {
    searchparams.departments.forEach(dept => queryParams.append('departments[]', dept));
  }
  if(searchparams.levels && searchparams.levels.length === 0) {
    queryParams.append('levels[]', 'none');
  } else if (searchparams.levels[0] !== "any") {
    searchparams.levels.forEach(level => queryParams.append('levels[]', level));
  }

  if (searchparams.SQL) {
    queryParams.append("SQL", searchparams.SQL);
  }
  queryParams.append("use_courses", searchparams.use_courses);

  searchparams.courses.forEach((course, index) => {
    queryParams.append(`courses[${index}][unique_identifier]`, course.unique_identifier);
    queryParams.append(`courses[${index}][grade]`, course.grade);
  });
  if (session_token===undefined) {
    queryParams.append("session_token", "none");
  } else {
    queryParams.append("session_token", session_token);
  }
  //console.log(JSON.stringify(searchparams))
  //console.log(`queryt: ${queryParams.toString()}`);

  try {
    const response = await fetch(`/courses/search?${queryParams.toString()}`, {
      method: 'GET',
      headers: { 'Accept': 'application/json', 'Authorization': `Bearer ${session_token}`
       }
    });

    if (response.ok) {
      const search_res = await response.json();
      // console.log(`Received response: ${JSON.stringify(search_res, undefined, 4)}`);
      successCallback(search_res);
      if (searchparams.courses.length > 0 && session_token) {
        addCoursesToUser(searchparams.courses, session_token)
      }
    } else {
      SearchFailCallback.trigger("Failed to fetch search result.");
      throw new Error(`Failed to fetch search result. Response status: ${response.status}`);
    }
  } catch (error) {
    SearchFailCallback.trigger("Error during course fetch.");
    console.error("Error during course fetch:", error);
  }
};