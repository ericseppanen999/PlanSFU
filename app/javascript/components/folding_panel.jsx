import React, {useRef, useEffect} from "react";
import "./folding_panel.css"

export const FoldingPanel = ({is_open, set_open_callback, className, children}) => {
    const panel_ref = useRef(null);

    useEffect(() => {
        function handle_click(event){
            if (panel_ref.current && !panel_ref.current.contains(event.target)) {
                set_open_callback(false)
            }
        }

        document.addEventListener("mouseup", handle_click);
    }, []);

    return (
        <div ref={panel_ref} className={`folding_panel ${className} ${!is_open ? ` hide_panel` : ``}`}>
            {children}
        </div>
    )
}