import React, { useState } from 'react';
import "./search_bar_and_dropdown.css";

const SearchBarWithDropdown = () => {
    const [searchTerm, setSearchTerm] = useState('');
    const [showDropdown, setShowDropdown] = useState(false);

    const handleSearchChange = (event) => {
        setSearchTerm(event.target.value);
    };

    const toggleDropdown = () => {
        setShowDropdown(!showDropdown);
    };

    return (
        <div className="search_bar_container">
            <input
                type="text"
                value={searchTerm}
                onChange={handleSearchChange}
                placeholder="Search"
            />
            <button onClick={toggleDropdown}>
                Advanced Search
            </button>
            {showDropdown && (
                <div className="dropdown_menu">
                    <h3>Search in</h3>
                    <div>
                        <label>
                            <input type="radio" name="searchIn" value="title" />
                            title
                        </label>
                        <label>
                            <input type="radio" name="searchIn" value="department" />
                            department
                        </label>
                        <label>
                            <input type="radio" name="searchIn" value="instructors" />
                            instructors
                        </label>
                        <label>
                            <input type="radio" name="searchIn" value="description" />
                            description
                        </label>
                        <label>
                            <input type="radio" name="searchIn" value="campuses" />
                            campuses
                        </label>
                    </div>
                    <h3>Department</h3>
                    <div>
                        <label>
                            <input type="radio" name="department" value="math" />
                            cmpt
                        </label>
                        <label>
                            <input type="radio" name="department" value="cmpt" />
                            math
                        </label>
                        <label>
                            <input type="radio" name="department" value="macm" />
                            macm
                        </label>
                    </div>
                    <h3>Level</h3>
                    <div>
                        <label>
                            <input type="radio" name="level" value="1xx" />
                            1xx
                        </label>
                        <label>
                            <input type="radio" name="level" value="2xx" />
                            2xx
                        </label>
                        <label>
                            <input type="radio" name="level" value="3xx" />
                            3xx
                        </label>
                        <label>
                            <input type="radio" name="level" value="4xx" />
                            4xx
                        </label>
                    </div>
                </div>
            )}
        </div>
    );
};

export { SearchBarWithDropdown };