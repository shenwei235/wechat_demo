env = ENV["RAILS_ENV"] || "staging"

root = "/mnt/wechat_demo/current"
working_directory root
preload_app true
timeout 30

pid "/tmp/unicorn.flex-messenger.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.sock"
worker_processes 2
