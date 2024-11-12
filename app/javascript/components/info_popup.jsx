import React, {useRef, useEffect, useState} from "react";
import { InfoIcon } from "./icons";
import "./info_popup.css"

export const InfoPopup = ({className, children}) => {
    const [showPanel, setShowPanel] = useState(0) // 0: hide, 1: weak show, 2: strong show
    const panel_ref = useRef(null);
    const button_ref = useRef(null);

    useEffect(() => {
        function handle_click(event){
            if (panel_ref.current && button_ref.current && !(panel_ref.current.contains(event.target) || button_ref.current.contains(event.target))) {
                setShowPanel(0);
            }
        }

        document.addEventListener("mouseup", handle_click);
    }, []);

    function toggleShow(){
        setShowPanel(showPanel != 2 ? 2 : 0);
    }

    function showWeak(){
        if (showPanel != 2){
            setShowPanel(1);
        }
    }

    function hideWeak(){
        if (showPanel != 2){
            setShowPanel(0);
        }
    }

    // show if: hovering over info button or info panel
    // or info button is clicked
    // hide if clicked outside of info panel

    return (
        <>
            <button name="show-note" aria-label="Show note" ref={button_ref} className={`info_hover_tag ${showPanel ? ` show_active` : ``}`} onClick={toggleShow} onMouseEnter={showWeak} onMouseLeave={hideWeak}>
                <InfoIcon className="info_button_icon"/>
                <div ref={panel_ref} className={`info_popup_panel horizontal-stack ${className ? className : ``} ${!showPanel ? ` hide_panel` : ``}`}>
                    <div className="info_popup_rect">
                        {children}
                    </div>
                </div>
            </button>
        </>
    )
}