This document outlines how various systems interact to respond to an interaction\
Each pipeline should start with an external event and end at some final state

#### Main Page Load Pipeline
1. Request to load `/articles` recieved
2. Request routed to `articles#index` (`articles_controller.rb`) as specified in `routes.rb`
3. View `views/articles/intex.html.erb` begins compiliation to html page
4. Webpack called to add compiled react code to index.html
5. Compiled html sent to user

#### Course Load Pipeline
1. Search terms updated (`javascript/components/search_bar_and_dropdown.jsx`)
2. Search terms parsed to url query & request is sent (`javascript/components/searchCourses.js`)
3. Courses controller receives the request & processes search terms (`app/controllers/courses_controller.rb`)
4. SQL query is constructed and executed (`app/controllers/courses_controller.rb - search_courses`)
5. Query results are serialized and sent back as JSON
6. Frontend receives JSON data from the fetch request (`javascript/components/searchCourses.js`)
7. The data is passed to a React component and dynamically generates HTML elements.


#### Sign In Pipeline
1. The user starts the sign-in process by clicking the "Login" button.
2. Request to /cas_sessions/new received: Routed to cas_sessions#new.
3. creates the login URL for CAS and sends the user there.
4. On the CAS server, the user enters credentials.
5. The CAS server verifies the credentials; if they are correct, it opens a ticket and sends the user back to the app.
6. Request to /cas_sessions/create received: Routed to cas_sessions#create.
7. Generate or locate the user; verifies the ticket.
8. Sets session[:cas_user] with the authenticated user's email.
9. User is redirected appropriately to original page or root.
10. User is logged in and ready to use the application.
