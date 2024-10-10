class SearchPanel {
    constructor(panel){
        this.search_res = [];
        this.mainPanel = panel;
        this.coursePanel = panel.querySelector(`#search_grid`);
    }

    async updateSearchResults(query){
        this.setDisplayLoading();
        const response = await fetch(`courses?searchquery=${query}`);
        if (response.ok) {
            search_res = await response.json();
            //console.log(`response data: ${JSON.stringify(search_res.message, undefined, 4)}`);
            updateSearchDisplay();   
        } else {
            throw new Error(`Failed to fetch search result. Response status: ${response.status}`);
        }
        this.unsetDisplayLoading();
    }

    setDisplayLoading(){
        this.mainPanel.style.setProperty('--display-loading', '');
    }

    unsetDisplayLoading(){
        this.mainPanel.style.setProperty('--display-loading', 'none');
    }

    unsetDisplayNoResults(){
        this.mainPanel.style.setProperty('--display-no-results', '');
    }

    setDisplayNoResults(){
        this.mainPanel.style.setProperty('--display-no-results', 'none');
    }

    clearDisplay(){
        this.coursePanel.innerHTML = ``;
    }

    updateDisplay(){
        this.clearDisplay();
        /*
        clear previous results
        for each result
            push result as html to results
        */
    }
}