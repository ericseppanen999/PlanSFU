import React, { useState } from 'react';
import "./external_links_sidebar.css";

import facultyStructure from "./external_links.json";

const NestedGroup = ({ title, content, level }) => {
    const [isOpen, setIsOpen] = useState(false);

    const renderContent = () => {
        if (Array.isArray(content)) {
            return (
                <ul className="box_list">
                    {content.map((link, index) => (
                        <li key={index}>
                            <a href={link.url} target="_blank" rel="noopener noreferrer">
                                {link.name}
                            </a>
                        </li>
                    ))}
                </ul>
            );
        } else {
            return Object.entries(content).map(([key, value]) => (
                <NestedGroup key={key} title={key} content={value} level={level + 1} />
            ));
        }
    };

    return (
        <ul className={isOpen ? "minus_list" : "plus_list"}>
            <li className={`nested_group level_${level}`}>                        
                <div className="group_title" onClick={() => setIsOpen(!isOpen)}>{title}</div>
                {isOpen && (
                    <div className="group_content">
                        {renderContent()}
                    </div>
                )}
            </li>
        </ul>
    );
};

const ExternalLinksSidebar = () => {
    return (
        <div className="external_links_sidebar">
            <h3>Course Planning Links</h3>
            {Object.entries(facultyStructure).map(([faculty, departments]) => (
                <NestedGroup key={faculty} title={faculty} content={departments} level={1} />
            ))}
        </div>
    );
};

export { ExternalLinksSidebar };