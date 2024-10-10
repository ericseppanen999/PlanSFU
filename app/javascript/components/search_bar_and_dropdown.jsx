import React, { useState } from "react";
import "./search_bar_and_dropdown.css";
import { defaultQuery } from "./searchCourses.js";
import { SearchBar } from "./search_bar.jsx";
import { Checkbox } from "./checkbox.jsx";
import { changeQueryCallback } from "./callback.js";

function matchesSearch(category, term) {
  return category.findIndex((e) => e === term || e === "any") != -1;
}

const SearchBarWithDropdown = () => {
  const [searchQuery, setSearchQuery] = useState(defaultQuery);
  const [showDropdown, setShowDropdown] = useState(false);

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
        }
        // remove target term
        idx = query[category].indexOf(term);
        if (idx !== -1) {
          query[category].splice(idx, 1);
        }
      }
      changeQueryCallback.trigger(query);
      return query;
    });
  };

  return (
    <div className="search_bar_container">
      <div className="horizontal-stack">
        <SearchBar onChange={handleSearchChange} />
        <div className="padding_medium"></div>
        <button id="advanced_search_button" onClick={toggleDropdown}>
          Advanced Search
        </button>
      </div>
      {showDropdown && (
        <div>
          <div className="dropdown_menu">
            <div>
              <h3>Search in</h3>
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
            </div>
            <div>
              <h3>Departments</h3>
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
            </div>

            <div>
              <h3>Levels</h3>
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
        </div>
      )}
    </div>
  );
};

export { SearchBarWithDropdown };
