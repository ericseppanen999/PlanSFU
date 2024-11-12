import React, { useEffect, useState } from "react";
import "./search_bar_and_dropdown.css";
import { defaultQuery } from "./searchCourses.js";
import { SearchBar } from "./search_bar.jsx";
import { Checkbox } from "./checkbox.jsx";
import { changeQueryCallback, UpdateTermsCallback, UpdateSessionCallback } from "./callback.js";
import { FoldingPanel } from "./folding_panel.jsx";
import { InfoPopup } from "./info_popup.jsx";

export const all_categories = {
    search_in_props: ["title", "description", "instructors", "year", "term"],
    departments: ["math", "cmpt", "macm", "ensc", "phys", "chem", "stat"],
    levels: ["1xx", "2xx", "3xx", "4xx"]
};

// returns if a term is in a list of any is in the list
function matchesSearch(category, term) {
  return category.findIndex((e) => e === term || e === "any") != -1;
}

// the component for the main searchbar
const SearchBarWithDropdown = () => {
  const [searchQuery, setSearchQuery] = useState(defaultQuery);
  const [showDropdown, setShowDropdown] = useState(false);

  // update the search courses when term tabs are updated
  useEffect(() => {
    UpdateTermsCallback.subscribe((terms) => {
      let search_courses = [];
      for (let term of terms){
        search_courses.push(...(term.courses.map((course) => {return {unique_identifier: course.unique_identifier, grade: course.grade}})));
      }
      setSearchQuery((query) => {
        query.courses = search_courses;
  
        changeQueryCallback.trigger(query);
        return query;
      });
    })
  }, [])

  // update session token when session is updated
  useEffect(() => {
    UpdateSessionCallback.subscribe((session) => {
      setSearchQuery((query) => {
        query.session_token = session;
  
        changeQueryCallback.trigger(query);
        return query;
      });
    })
  }, [])

  // set the searchstring when the text input is changed
  const handleSearchChange = (value) => {
    setSearchQuery((query) => {
      query.searchstring = value;
      changeQueryCallback.trigger(query);
      return query;
    });
  };

  const toggleDropdown = () => {
    setShowDropdown(!showDropdown);
  };

  // sets a search parameter in the search query
  const setSearchParam = (category, term, value) => {
    setSearchQuery((query) => {
      if (value) {
        // add term if needed
        if (!matchesSearch(query[category], term)) {
          query[category].push(term);
        }
      } else {
        // remove any operator if it exists
        let idx = query[category].indexOf("any");
        if (idx !== -1) {
          query[category].splice(idx, 1);
          // convert any to a list of all options (other than the unselected one)
          for (const cat_term of all_categories[category]){
            if (cat_term !== term) query[category].push(cat_term);
          }
        } else {
            // remove target term
            idx = query[category].indexOf(term);
            if (idx !== -1) {
            query[category].splice(idx, 1);
            }
        }
      }

      changeQueryCallback.trigger(query);
      return query;
    });
  };

  // update whether or not to apply selected courses to the search
  const setSearchUseCourses = (value) => {
    setSearchQuery((query) => {
      query.use_courses = value;
      changeQueryCallback.trigger(query);
      return query;
    });
  };

  return (
    <>
    <div className="horizontal-stack">
      <Checkbox
        id="use_courses"
        label="Apply Selected Courses"
        defaultChecked={defaultQuery.use_courses}
        onChange={(checked) =>
          setSearchUseCourses(checked)
        }
      />
      <div className="padding_medium"></div>
      <InfoPopup>Toggles whether course prereqs apply to the search results.</InfoPopup>
    </div>
    <br></br>
    <div className="search_bar_container">
      <div className="horizontal-stack">
        <SearchBar id="course_search" name="course_search" onChange={handleSearchChange} />
        <div className="padding_medium"></div>
        <div>
          <button name="advanced_search_button" id="advanced_search_button" title="Show advanced search dropdown" onClick={toggleDropdown}>
            Advanced Search
          </button>
          <FoldingPanel className="search_dropdown" is_open={showDropdown} set_open_callback={setShowDropdown}>
            <div className="dropdown_menu">
              <div>
                <div className="horizontal-stack">
                  <h3>Search in</h3>
                  <div className="padding_medium"></div>
                  <InfoPopup>Select course attributes to apply the search string to.</InfoPopup>
                </div>
                <Checkbox
                  id="search_in_title"
                  label="title"
                  defaultChecked={matchesSearch(
                    defaultQuery.search_in_props,
                    "title"
                  )}
                  onChange={(checked) =>
                    setSearchParam("search_in_props", "title", checked)
                  }
                />
                <Checkbox
                  id="search_in_description"
                  label="description"
                  defaultChecked={matchesSearch(
                    defaultQuery.search_in_props,
                    "description"
                  )}
                  onChange={(checked) =>
                    setSearchParam("search_in_props", "description", checked)
                  }
                />
                <Checkbox
                  id="search_in_instructors"
                  label="instructors"
                  defaultChecked={matchesSearch(
                    defaultQuery.search_in_props,
                    "instructors"
                  )}
                  onChange={(checked) =>
                    setSearchParam("search_in_props", "instructors", checked)
                  }
                />
                <Checkbox
                  id="search_in_year"
                  label="year"
                  defaultChecked={matchesSearch(
                    defaultQuery.search_in_props,
                    "year"
                  )}
                  onChange={(checked) =>
                    setSearchParam("search_in_props", "year", checked)
                  }
                />
                <Checkbox
                  id="search_in_term"
                  label="term"
                  defaultChecked={matchesSearch(
                    defaultQuery.search_in_props,
                    "term"
                  )}
                  onChange={(checked) =>
                    setSearchParam("search_in_props", "term", checked)
                  }
                />
              </div>
              <div>
                <div className="horizontal-stack">
                  <h3>Departments</h3>
                  <div className="padding_medium"></div>
                  <InfoPopup>Select departments to include in the results.</InfoPopup>
                </div>
                <Checkbox
                  id="dept_math"
                  label="math"
                  defaultChecked={matchesSearch(defaultQuery.departments, "math")}
                  onChange={(checked) =>
                    setSearchParam("departments", "math", checked)
                  }
                />
                <Checkbox
                  id="dept_cmpt"
                  label="cmpt"
                  defaultChecked={matchesSearch(defaultQuery.departments, "cmpt")}
                  onChange={(checked) =>
                    setSearchParam("departments", "cmpt", checked)
                  }
                />
                <Checkbox
                  id="dept_macm"
                  label="macm"
                  defaultChecked={matchesSearch(defaultQuery.departments, "macm")}
                  onChange={(checked) =>
                    setSearchParam("departments", "macm", checked)
                  }
                />
                <Checkbox
                  id="dept_ensc"
                  label="ensc"
                  defaultChecked={matchesSearch(defaultQuery.departments, "ensc")}
                  onChange={(checked) =>
                    setSearchParam("departments", "ensc", checked)
                  }
                />
                <Checkbox
                  id="dept_phys"
                  label="phys"
                  defaultChecked={matchesSearch(defaultQuery.departments, "phys")}
                  onChange={(checked) =>
                    setSearchParam("departments", "phys", checked)
                  }
                />
                <Checkbox
                  id="dept_chem"
                  label="chem"
                  defaultChecked={matchesSearch(defaultQuery.departments, "chem")}
                  onChange={(checked) =>
                    setSearchParam("departments", "chem", checked)
                  }
                />
                <Checkbox
                  id="dept_stat"
                  label="stat"
                  defaultChecked={matchesSearch(defaultQuery.departments, "stat")}
                  onChange={(checked) =>
                    setSearchParam("departments", "stat", checked)
                  }
                />
              </div>

              <div>
                <div className="horizontal-stack">
                  <h3>Levels</h3>
                  <div className="padding_medium"></div>
                  <InfoPopup>Select levels of course to search in. (eg: CMPT 276 would be in 2xx)</InfoPopup>
                </div>
                <Checkbox
                  id="level_1"
                  label="1xx"
                  defaultChecked={matchesSearch(defaultQuery.levels, "1xx")}
                  onChange={(checked) => setSearchParam("levels", "1xx", checked)}
                />
                <Checkbox
                  id="level_2"
                  label="2xx"
                  defaultChecked={matchesSearch(defaultQuery.levels, "2xx")}
                  onChange={(checked) => setSearchParam("levels", "2xx", checked)}
                />
                <Checkbox
                  id="level_3"
                  label="3xx"
                  defaultChecked={matchesSearch(defaultQuery.levels, "3xx")}
                  onChange={(checked) => setSearchParam("levels", "3xx", checked)}
                />
                <Checkbox
                  id="level_4"
                  label="4xx"
                  defaultChecked={matchesSearch(defaultQuery.levels, "4xx")}
                  onChange={(checked) => setSearchParam("levels", "4xx", checked)}
                />
              </div>
            </div>
          </FoldingPanel>
        </div>
      </div>
    </div>
    </>
  );
};

export { SearchBarWithDropdown };
