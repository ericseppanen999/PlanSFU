const defaultQuery = {
    searchstring: "",
    search_in_props: ["title", "description"],
    terms: "all",
    departments: "all",
    levels: "all",
    SQL: ""
};

c = {
    searchstring: "",
    search_in_props: ["title", "description"],
    //search_in_props: "all",
    terms: "all",
    //terms: [{year: "2023", term: "any"}],
    //terms: [{year: "any", term: "fall"}],
    departments: ["all"],
    levels: ["all"],
    SQL: ""
}

export const fetchCourses = async (successCallback, searchparams = defaultQuery) => {
    let query = ``;
    for (const key in searchparams){
        query += `${encodeURI(key)}=${encodeURI(searchparams[key])}&`;
    }
    const response = await fetch(`/courses/search?${query}`, {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });
    if (response.ok) {
      let search_res = await response.json();
      console.log(`response data: ${JSON.stringify(search_res, undefined, 4)}`);
      successCallback(search_res);
    } else {
      throw new Error(
        `Failed to fetch search result. Response status: ${response.status}`
      );
    }
};