import React, { useState } from 'react';
import "./checkbox.css"

export const Checkbox = ({ id, label, onChange=(state)=>{}, defaultChecked=false}) => {
    const [checked, setChecked] = useState(defaultChecked);

    return (
        <div className="checkbox_container horizontal-stack">
            <input 
                type="checkbox" 
                className="checkbox_input"
                id={id} 
                name={id}
                value={id}
                onChange={() => setChecked((checked) => { 
                    onChange(!checked); 
                    return !checked;
                })}
                checked={checked}
            />
            <label htmlFor={id} className="checkbox_label">{label}</label>
        </div>
    )
}