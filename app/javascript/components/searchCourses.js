// the default 
export const defaultQuery = {
  searchstring: "",
  search_in_props: ["title", "description"],
  terms: [ {year: "any", term: "any"} ],
  departments: ["any"],
  levels: ["any"],
  SQL: ""
}

// returns a course list to successCallback if courses are successfully fetched, given a search query
export const fetchCourses = async (successCallback, searchparams = defaultQuery) => {
  // build query from search parameters
  let query = ``;
  for (const key in searchparams){
    query += `${encodeURI(key)}=${encodeURI(searchparams[key])}&`;
  }
  console.log(query);
  // get courses from the server
  const response = await fetch(`/courses/search?${query}`, {
    method: 'GET',
    headers: { 'Accept': 'application/json' }
  });
  // return courses to callback
  if (response.ok) {
    let search_res = await response.json();
    console.log(`response data: ${JSON.stringify(search_res, undefined, 4)}`);
    successCallback(search_res);
  } else { // an error has occured
    throw new Error(
      `Failed to fetch search result. Response status: ${response.status}`
    );
  }
};