import React from "react";
import { Search } from "./icons.jsx"
import "./search_bar.css"

// a component for a search bar with a search icon
export const SearchBar = ({ onChange=()=>{} }) => (
    <div className="search_bar">
        <input type="text" className="search_bar_input" placeholder="Search" onBlur={(event) => onChange(event.target.value)}></input>
        {/*render search icon*/}
        <Search />
    </div>
  );