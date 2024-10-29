.
├── app                     # the main code directory
│   ├── assets              # assets used in the app
│   ├── controllers         # handlers for requests
│   ├── models              # defines how data should be stored
│   ├── views               # pages the user can view
│   ├── javascript          # javascript used by webpack to create the html
│   |   ├── components      # react components, stylesheets, and js which are referenced
│   |   └── packs           # entrypoints for webpack
|   ...
├── config
│   ├── routes.rb           # specifies which controllers should be used for requests
│   ├── shakapacker.yml     # shakapacker config (webpack)
|   ├── application.rb      # rails entrypoint
|   ...
├── db
|   ├── ...
├── docs
|   ├── ...
├── test
|   ├──                     # do I look like someone who can spend all day writing fucking selenium and ruby scripts
├── assets                  # assets used in the readme and other documents
├── Rakefile                # file for defining rails tasks
├── Gemfile                 # ruby packages to include
├── package.json            # javascript packages to include
├── babel.config.js         # config for the js transpiler
├── Dockerfile              # config for the production environment
├── postcss.config.js       # config for postcss
├── pipelines.md            # documentation on system interactions
├── README.MD
...
