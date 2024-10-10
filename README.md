![PlanSFU](assets/PlanSFU.svg "PlanSFU")\
A course planner for undergrads at SFU. A group project for CMPT 276 D300, Fall 2024

## Iteration 1 Features ##
- Filtered search with options
- Search by SQL
- Sign in (with autofill if possible) (postponed)
- Server-side state storage when signed in (postponed)

## Running The Server Locally ##
### Prerequisites ###
Ruby
NPM

### Install Dependencies: ###
run `bundler install`\
run `npm install`

### Run the Development Server ###
run `ruby bin/rails server` from the main project folder\
navigate to `127.0.0.1:3000/articles` on your browser\

## Iteration 1 Retrospective ##
- What worked:
    - Strong start with research and feasibility, followed by defining requirements
    - Weekly in-person meetings
- What didn't:
    - Working without an initial UI sketch
    - More feasability work would have saved time wasted on cookies
- What to change in iteration 2
    - Setup github actions to automate testing
    - Make a central development server to reflect the current state of the project and use for debugging
    - Set weekly development targets

## Feature Tracking ##
We used Trello for feature and bug tracking
![Trello1](assets/Trello1.png "Trello1")\
![Trello2](assets/Trello2.png "Trello2")

## Test results ##
QA testing was used with the following test cases:

search a string in the bar with results
- expected: valid results are shown
- passed: yes

search a string in the bar without results
- expected: no results message is shown
- passed: yes

search an empty string
- expected: all courses meeting advanced criteria are shown
- passed: yes

search a long string
- expected: handled cleanly if request is too long
- passed: yes

select a check
- expected: check is set and search updates appropriately
- passed: yes

deselect a check
- expected: check is unset and search updates appropriately
- passed: yes

select all checks in a category
- expected: search updates appropriately
- passed: yes

deselect all checks in a category
- expected: search updates appropriately
- passed: yes

toggle the advanced search display
- expected: advanced search shows
- passed: yes

spam checks
- expected: checks keep track of their state correctly & search updates correctly
- passed: yes

spam the advanced search toggle
- expected: advanced search and toggle continue to operate correctly
- passed: yes

add a course
- expected: course is added to correct term tab
- passed: yes

remove a course
- expected: course is removed from correct tab
- passed: yes

add multiple courses
- expected: all courses are added to their correct tabs
- passed: yes

remove all courses
- expected: all courses are removed from their correct tabs
- passed: yes

add a duplicate course
- expected: no change to the tabs
- passed: yes

spam add courses
- expected: course tabs update appropriately
- passed: yes

select a course in a term tab
- expected: course expands to show more info
- passed: yes

remove a selected course
- expected: course is removed correctly and other courses can be selected
- passed: yes

spam click a course in a tab
- expected: course expands and stays expanded
- passed: yes

resize the page
- expected: ui scales reasonably
- passed: yes

resize the page with the advanced search open
- expected: advanced search maintains reasonable position on the page
- passed: yes