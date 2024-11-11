import React from "react";
import { SearchIcon } from "./icons.jsx"
import "./search_bar.css"

// a component for a search bar with a search icon
export const SearchBar = ({ onChange=()=>{} }) => (
    <div className="search_bar">
        <input type="search" className="search_bar_input" placeholder="Search" name="search" onBlur={(event) => onChange(event.target.value)}></input>
        {/*render search icon*/}
        <SearchIcon />
    </div>
  );