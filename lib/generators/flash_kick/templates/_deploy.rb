require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :deploy_to,     '/var/www/<%= FlashKick::VariableStore.variables['app_name'] %>'
set :app_path,      '/var/www/<%= FlashKick::VariableStore.variables['app_name'] %>/current'
set :user,          '<%= FlashKick::VariableStore.variables['server_user'] %>'
set :port,          '<%= FlashKick::VariableStore.variables['server_ssh_port'] %>'
set :repository,    '<%= FlashKick::VariableStore.variables['app_repo'] %>'
set :forward_agent, true

task :production do
  set :domain,        '<%= FlashKick::VariableStore.variables['server_domain'] %>'
  set :branch,        '<%= FlashKick::VariableStore.variables['app_repo_branch'] %>'
  set :rails_env,     'production'
  set :shared_paths,  ['config/database.yml', 'config/secrets.yml', 'log', 'tmp', '.env/production_env.yml']
end

task :environment do
  queue 'export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH'
  queue 'source ~/.session_vars'
end

task setup: :environment do
  queue "mkdir -m 750 -p #{deploy_to}/#{shared_path}/log"
  queue "mkdir -m 750 -p #{deploy_to}/#{shared_path}/config"
  queue "mkdir -m 750 -p #{deploy_to}/#{shared_path}/tmp/log"
  queue "mkdir -m 750 -p #{deploy_to}/#{shared_path}/tmp/pids"
  queue "mkdir -m 750 -p #{deploy_to}/#{shared_path}/tmp/sockets"
end

task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    to :launch do
      invoke :'server:restart'
    end
  end
end

namespace :server do
  task start: :environment do
    queue "cd #{app_path} && rails_env=#{rails_env} && bin/puma.sh start"
  end

  task stop: :environment do
    queue "cd #{app_path} && rails_env=#{rails_env} && bin/puma.sh stop"
  end

  task restart: :environment do
    queue "cd #{app_path} && rails_env=#{rails_env} && bin/puma.sh restart"
  end
end
