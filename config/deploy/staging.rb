set :application, "staging"
set :rails_env, 'development'

set :branch, 'develop'

role :app, '184.106.178.151'
role :web, '184.106.178.151'
role :db, '184.106.178.151', :primary => true

after 'deploy:migrate', "deploy:restart"
