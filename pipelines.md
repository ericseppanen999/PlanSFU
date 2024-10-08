This document outlines how various systems interact to respond to an interaction\
Each pipeline should start with an external event and end at some final state

#### Main Page Load Pipeline
1. Request to load `/articles` recieved
2. Request routed to `articles#index` (`articles_controller.rb`) as specified in `routes.rb`
3. View `views/articles/intex.html.erb` begins compiliation to html page
4. Webpack called to add compiled react code to index.html
5. Compiled html sent to user

#### Sign In