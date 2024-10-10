import React from "react";
import { Search } from "./icons.jsx"
import "./search_bar.css"

export const SearchBar = ({ onChange=()=>{} }) => (
    <div className="search_bar">
        <input type="text" className="search_bar_input" placeholder="Search" onBlur={(event) => onChange(event.target.value)}></input>
        <Search />
    </div>
  );