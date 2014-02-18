require 'capistrano/ext/multistage'
require 'bundler/capistrano'
set :repository,  "root@184.106.178.151:/git/clu2.git"

set :scm, :git
set :stages, [:staging, :production]
set :default_stage, :staging
set :user, "deploy"
set (:deploy_to) {"/var/www/clu2/#{application}/"}
set :use_sudo, false
default_run_options[:pty] = true

# configure whenever
set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { rails_env }
require "whenever/capistrano"

namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(release_path,'tmp','restart.txt')}"
  end

  namespace :symlinks do
    desc "Run all tasks in this namespace"
    task :default do
      run "echo \"Running all tasks in deploy:symlinks namespace...\""
    end

    desc "Create symlnks for database.yaml and environments files"
    task :database do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

    desc "Symlink an enviornment file to tmp/<env>.rb, where it will enhance/override the app's existing environment file."
    task :environment_override do
      run "mkdir -p #{release_path}/tmp"
      %w[development test production].each do |env|
        shared_env_path = "#{shared_path}/config/environments/#{env}.rb"
        run %Q(
          if [ -e "#{shared_env_path}" ]; then
            echo "Linking a tmp/#{env}.rb file to enhance/override the standard environment file...";
            ln -nfs #{shared_env_path} #{release_path}/tmp/#{env}.rb;
          fi
          )
      end
    end
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab store"
  end
end

namespace :bundle do
  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --without=test --no-update-sources"
  end
end

# custom symlinks callbacks
after   'deploy:update_code', 'deploy:symlinks'
after   'deploy:symlinks',
  'deploy:symlinks:database',
  'deploy:symlinks:environment_override',
  'deploy:migrate'
# bundler callback
before  "deploy:migrate", "bundle:install"
# delayed_job callbacks
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
# (probably) unneeded callbacks
after "deploy:symlink", "deploy:update_crontab"
  