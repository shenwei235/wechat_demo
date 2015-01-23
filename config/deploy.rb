require "bundler/capistrano"
require 'capistrano-unicorn'

set :user, 'ubuntu'
set :domain, '54.148.45.162'
set :application, "flex-messenger"
set :deploy_to, "/mnt/#{application}"
set :repository,  "git@git.oschina.net:yushine/flex-messager.git"
set :latest_release, "#{release_path}/website"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, domain
role :web, domain
role :db, domain, :primary => true

# default_run_options[:shell] = '/bin/bash --login'
ssh_options[:keys] ="~/flex.pem"
ssh_options[:forward_agent] = true

set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :rails_env, "production"

set :unicorn_pid, "/tmp/unicorn.flex-messenger.pid"
#set :unicorn_config_path, "#{current_path}/config/environments"
# set :unicorn_bin, "/usr/local/bin/unicorn_rails"
set :keep_releases, 5

# keep old assets around for 45 days for returning visitors with stale caches
# See deploy:assets:clean_expired task
set :expire_assets_after, 60 * 60 * 24 * 45  # 45 days in seconds

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :setup_config do
  desc "set up configuration dependencies"
  task :upload_database_config_yml, :roles => :web do
    # on roles(:app) do
    # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
    run "mkdir -p #{shared_path}/config"
    upload "config/database.yml", "#{shared_path}/config/database.yml"
    # upload! File.open("config/omniauth.yml"), "#{shared_path}/config/omniauth.yml"
    # execute :sudo, "service nginx restart"
    puts "Now edit the config files in #{shared_path}."
    # end
  end

  task :upload_nginx_config_file, :roles => :web do
    # on roles(:app) do
    # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
    run "mkdir -p #{shared_path}/config"
    upload "config/flex_messenger.conf", "#{shared_path}/config/flex_messenger.conf"
    run "sudo ln -sfn #{shared_path}/config/flex_messenger.conf /etc/nginx/conf.d/flex_messenger.conf"
    # run "sudo nginx -s reload -c #{shared_path}/config/flex_messenger.conf"
    # upload! File.open("config/omniauth.yml"), "#{shared_path}/config/omniauth.yml"
    run "sudo service nginx restart"
    puts "Now nginx is restarted."
    puts "Now edit the config files in #{shared_path}."
    # end
  end

  task :restore_database, :roles => :db do
    run "mkdir -p #{shared_path}/config"
    upload "../database/20141230.sql", "#{shared_path}/config/20141230.sql"
    run "/usr/bin/mysql -uroot -pshenwei235 flexmessenger_product_20141230 < #{shared_path}/config/20141230.sql"
  end

end

task :symlink_database_yml, :roles => :db do
#  run "rm #{release_path}/config/database.yml"
  run "ln -sfn #{shared_path}/config/database.yml
       #{release_path}/website/config/database.yml"
end

task :update_db, :roles => :db do
#  run "rm #{release_path}/config/database.yml"
  run "cd #{release_path}/website;export; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
end

after "deploy:finalize_update", "update_db"
after "deploy:assets:symlink", "symlink_database_yml"
after "deploy:restart", "unicorn:restart"
after "deploy:restart", "deploy:cleanup"