![PlanSFU](assets/PlanSFU.svg "PlanSFU")\
A course planner for undergrads at SFU. A group project for CMPT 276 D300, Fall 2024

## Iteration 1 Features ##
- Filtered search with options
- Search by SQL
- Sign in (with autofill if possible) (postponed)
- Server-side state storage when signed in (postponed)

## New Features in Iteration 2 ##
- Prereqs are now applied in searches
    - Prereqisites selected by the user in the term tabs are applied when the checkbox is selected, otherwise the search applies to all courses
- Courses displayed in the search are now from the actual sfu database
    - Data shown in the search results represent actual courses from the SFU API
    - *Not all departments are included at the moment
- Login functionality
    - The user can sign in with a username and password
    - The user can sign up with a username and password (of at least 6 characters)
- Search state storage
    - The current search state is stored to the server if the user is currently signed in
- Course planning link list
    - Links to course planning resources can be found for all departments nicely organized
- User can now set their grades for selected courses
    - Grades are stored to the user database
    - Grade requirements are applied to the search results when the checkbox to apply selected courses is checked

## Cut Features in Iteration 2 ##
- Autofilling courses on sign in
    - No API exists for this
- SFU CAS authentification
    - Removed due to difficulties implementing and loss of autofill feature
- Admin view
    - Removed in favor of testing page and automated prequisite generation
- Extra course and teacher info
    - Removed due to being out of scope for this application

## Features Not Yet Implmented in Iteration 2 ##
- Search by SQL query
    - The user can enter an SQL query to filter courses with
    - The SQL query is applied to the search
    - Continuation: complete by 11/6
- Find recommended courses
    - Continuation: complete by 11/13

## Running The Server Locally ##
### Prerequisites ###
Ruby
NPM

### Install Dependencies: ###
run `bundler install`\
run `npm install`

### Run the Development Server ###
run `ruby bin/rails server` from the main project folder\
navigate to `127.0.0.1:3000` on your browser\

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

## Iteration 2 Retrospective ##
- We attempted to solve the final crunch we had in iteration 1 by setting weekly development targets
    - However, as it was in the middle of exams and due to overly ambitious targets, we quickly flew past the first deadline, leading us to fall behind on development.
- We were also unable to find a host for our development server


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