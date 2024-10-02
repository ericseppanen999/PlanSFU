![PlanSFU](assets/PlanSFU.svg "PlanSFU")\
A course planner for undergrads at SFU. A group project for CMPT 276 D300, Fall 2024

## Iteration 1 Features ##
- Filtered search with options
- Search by SQL
- Sign in (with autofill if possible)
- Server-side state storage when signed in

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
    - Make a central development server to reflect the current state
    - Set weekly development targets