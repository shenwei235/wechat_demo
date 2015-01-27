# config valid only for Capistrano 3.1
lock '3.3.5'

set :user, 'ubuntu'
set :application, "wechat_demo"
set :deploy_to, "/mnt/#{fetch(:application)}"
set :deploy_via, :remote_cache
set :repo_url,  "git@github.com:shenwei235/#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git
set :branch, ENV['BRANCH'] || 'master'
set :scm_verbose, true
set :use_sudo, false

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :unicorn_pid, "/tmp/unicorn.wechat_demo.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_rack_env, -> { fetch(:rails_env) }

SSHKit.config.command_map[:rake]  = "bundle exec rake" #8
SSHKit.config.command_map[:rails] = "bundle exec rails"

# keep old assets around for 45 days for returning visitors with stale caches
# See deploy:assets:clean_expired task
set :expire_assets_after, 60 * 60 * 24 * 45  # 45 days in seconds

# Default value for keep_releases is 5
set :keep_releases, 5

# namespace :deploy do
#
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end
#
#   after :publishing, :restart
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end

namespace :deploy do

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    branch = fetch(:branch)
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes or make sure you've"
      puts "checked out the branch: #{branch} as you can only deploy"
      puts "if you've got the target branch checked out"
      exit
    end
  end

  desc "set up configuration dependencies"
  task :upload_database_config_yml do
    on roles(:app) do
      # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      execute "mkdir -p #{shared_path}/config"
      upload! "config/database.yml", "#{shared_path}/config/database.yml"
      # upload! File.open("config/omniauth.yml"), "#{shared_path}/config/omniauth.yml"
      # execute :sudo, "service nginx restart"
      puts "Now edit the config files in #{shared_path}."
    end
  end

  task :upload_nginx_config_file do
    on roles(:app) do
      # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      execute "mkdir -p #{shared_path}/config"
      upload! "config/wechat_demo.conf", "#{shared_path}/config/wechat_demo.conf"
      execute "sudo ln -sfn #{shared_path}/config/wechat_demo.conf /etc/nginx/conf.d/wechat_demo.conf"
      # run "sudo nginx -s reload -c #{shared_path}/config/flex_messenger.conf"
      # upload! File.open("config/omniauth.yml"), "#{shared_path}/config/omniauth.yml"
      execute "sudo service nginx restart"
      puts "Now nginx is restarted."
      puts "Now edit the config files in #{shared_path}."
    end
  end

  task :restore_database do
    on roles(:db) do
      execute "mkdir -p #{shared_path}/config"
      upload! "config/20150127.sql", "#{shared_path}/config/20150127.sql"
      execute "/usr/bin/mysql -uroot -pshenwei235 wechat_demo_20150123 < #{shared_path}/config/20150127.sql"
    end
  end

  before :deploy, "deploy:check_revision"
  # after "deploy:check", "deploy:setup_config"

  # after 'deploy:publishing', 'deploy:restart'
  # after "deploy:publishing", "unicorn:restart"
  after :finished, "deploy:cleanup" # keep only the last 5 releases
  after :finished, "unicorn:legacy_restart"
end

# task :symlink_database_yml, :roles => :db do
# #  run "rm #{release_path}/config/database.yml"
#   run "ln -sfn #{shared_path}/config/database.yml
#        #{release_path}/website/config/database.yml"
# end
#
# task :update_db, :roles => :db do
# #  run "rm #{release_path}/config/database.yml"
#   run "cd #{release_path};export; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
# end
#
# after "deploy:finalize_update", "update_db"
# after "deploy:assets:symlink", "symlink_database_yml"
# after "deploy:restart", "unicorn:restart"
# after "deploy:restart", "deploy:cleanup"
