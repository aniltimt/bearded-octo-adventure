set :application, "production"
set :rails_env, 'production'

set :branch, 'master'

role :app, '184.106.178.151'
role :web, '184.106.178.151'
role :db, '184.106.178.151', :primary => true

after 'deploy:migrate', 'deploy:asset_compile'
after 'deploy:asset_compile', "deploy:restart"


namespace :deploy do

  task :asset_compile, :roles => :app, :except => { :no_release => true } do
    run "cd  #{release_path}; bundle exec rake assets:pre_compile RAILS_ENV=#{rails_env}"
  end


end
