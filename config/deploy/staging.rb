set :stage, :production
set :rails_env, "production"

role :app, %w{ubuntu@54.148.45.162}
role :web, %w{ubuntu@54.148.45.162}
role :db,  %w{ubuntu@54.148.45.162}

server "54.148.45.162", user: "ubuntu",roles: %w{web app db}, primary: true

set :unicorn_worker_count, 2

set :pty, false

set :ssh_options, {
  keys: %w(~/flex.pem),
  forward_agent: true
}
