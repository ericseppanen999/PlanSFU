![PlanSFU](assets/PlanSFU.svg "PlanSFU")\
A course planner for undergrads at SFU. A group project for CMPT 276 D300, Fall 2024


## please note that this branch is outdated, an upto date version is on the sfu enterprise github ##



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


## Top Level Directory Map ##
.\
├── app                     # the main code directory\
│   ├── assets              # assets used in the app\
│   ├── controllers         # handlers for requests\
│   ├── models              # defines how data should be stored\
│   ├── views               # pages the user can view\
│   ├── javascript          # javascript used by webpack to create the html\
│   |   ├── components      # react components, stylesheets, and js which are referenced\
│   |   └── packs           # entrypoints for webpack\
|   ...\
├── config\
│   ├── routes.rb           # specifies which controllers should be used for requests\
│   ├── shakapacker.yml     # shakapacker config (webpack)\
|   ├── application.rb      # rails entrypoint\
|   ...\
├── db                      # database data\
├── docs                    # documentation\
├── test                    # testing scripts\
├── assets                  # assets used in the readme and other documents\
├── Rakefile                # file for defining rails tasks\
├── Gemfile                 # ruby packages to include\
├── package.json            # javascript packages to include\
├── babel.config.js         # config for the js transpiler\
├── Dockerfile              # config for the production environment\
├── postcss.config.js       # config for postcss\
├── README.MD\
...

## Test results ##
Unit tests were applied for the following cases:


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
- passed: no - when input length > (1024 * 10)

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

sign-in dropdown selects
- expected: sign-in dropdown with fields should appear
- passed: yes

sign-in dropdown deselects
- expected sign-in dropdown with fields should disappear smoothly
- passed: yes

adding a course filters search results
- expected adding a course should remove all instances of the course from search results
- passed: yes

removing a course filters search results
- expected: removing a course from selected should put that course back into the search results
- passed: yes



open course planning section
- expected: subcategories are shown
- passed: yes

close course planning section
- expected: subcategories are hidden
- passed: yes

toggle use selected courses
- expected: courses already taken are hidden/shown
- passed: yes

enter a grade
- expected: courses reload to show new results
- passed: yes
