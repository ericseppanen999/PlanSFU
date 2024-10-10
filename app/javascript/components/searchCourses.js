export const defaultQuery = {
  searchstring: "",
  search_in_props: ["title", "description"],
  terms: [ {year: "any", term: "any"} ],
  departments: ["any"],
  levels: ["any"],
  SQL: ""
}

export const fetchCourses = async (successCallback, searchparams = defaultQuery) => {
  let query = ``;
  for (const key in searchparams){
    query += `${encodeURI(key)}=${encodeURI(searchparams[key])}&`;
  }
  console.log(query);
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