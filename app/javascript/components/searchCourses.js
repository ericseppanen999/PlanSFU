export const defaultQuery = {
  searchstring: "",
  search_in_props: ["title", "description"],
  terms: [{ year: "any", term: "any" }],
  departments: ["any"],
  levels: ["any"],
  SQL: ""
};

export const fetchCourses = async (successCallback, searchparams = defaultQuery) => {
  console.log("checking course fetch...");

  const queryParams = new URLSearchParams();
  queryParams.append("searchstring", searchparams.searchstring);
  searchparams.search_in_props.forEach(prop => queryParams.append('search_in_props[]', prop));

  searchparams.terms.forEach((term) => {
    queryParams.append('terms[][year]', term.year);
    queryParams.append('terms[][term]', term.term);
  });

  if (searchparams.departments.length > 0 && searchparams.departments[0] !== "any") {
    searchparams.departments.forEach(dept => queryParams.append('departments[]', dept));
  }

  if (searchparams.levels.length > 0 && searchparams.levels[0] !== "any") {
    searchparams.levels.forEach(level => queryParams.append('levels[]', level));
  }

  if (searchparams.SQL) {
    queryParams.append("SQL", searchparams.SQL);
  }

  console.log(`queryt: ${queryParams.toString()}`);

  try {
    const response = await fetch(`/courses/search?${queryParams.toString()}`, {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });

    if (response.ok) {
      const search_res = await response.json();
      console.log(`Received response: ${JSON.stringify(search_res, undefined, 4)}`);
      successCallback(search_res);
    } else {
      throw new Error(`Failed to fetch search result. Response status: ${response.status}`);
    }
  } catch (error) {
    console.error("Error during course fetch:", error);
  }
};