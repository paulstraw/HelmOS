require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :deploy_to, '/home/deployer/helmos'
set :repository, 'git@github.com:paulstraw/thegalaxy.git'
set :branch, 'master'
set :term_mode, nil
set :user, 'deployer'
set :forward_agent, true

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-2.1.2@default]'
end

# Put any custom mkdir's in here for when `mina set_up` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.

# don't forget to ssh to the box and `gem install thin`, for whatever stupid reason
task :set_up => :environment do
  queue! %[mkdir -p "#{deploy_to}/current"]
  queue! %[mkdir -p "#{deploy_to}/releases"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/thin.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/thin.yml'."]

  # Set up /shared/tmp/thin.pid for restarting servers
  queue! %[mkdir -p "#{deploy_to}/tmp"]
  queue! %[touch "#{deploy_to}/tmp/thin.pid"]
end

desc 'Deploys the current version to an app server.'
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      # queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

desc 'Deploys the current version to a worker.'
task :deploy_worker => :environment do
  invoke :deploy
  queue! "cd #{deploy_to}/current ; mkdir -p tmp/pids ; RAILS_ENV=#{env} bin/delayed_job restart"
end


desc 'Restart thin instances'
task :restart_thins do
  # queue! 'thin restart -C /etc/thin/helmos.yml'
  queue! "thin restart -C #{deploy_to}/#{shared_path}/config/thin.yml"
end

set :staging_app_servers, %w[104.131.139.225]
set :staging_db_servers, %w[104.236.145.104]
set :staging_redis_servers, %w[104.236.145.72]
set :staging_worker_servers, %w[104.236.145.75]
desc 'Set up staging'
task :set_up_staging do
  set :env, 'staging'

  isolate do
    staging_app_servers.each do |domain|
      set :domain, domain
      invoke :set_up
      run!
    end

    staging_worker_servers.each do |domain|
      set :domain, domain
      invoke :set_up
      run!
    end
  end
end

desc 'Deploy to staging'
task :deploy_staging do
  set :branch, 'staging'
  set :env, 'staging'

  isolate do
    staging_app_servers.each do |domain|
      set :domain, domain
      invoke :deploy
      invoke :restart_thins
      run!
    end

    staging_worker_servers.each do |domain|
      set :domain, domain
      invoke :deploy
      run!
    end
  end
end


# set :production_domains, %w[helmos.net]
# desc 'Deploy to production'
# task :deploy_production do
#   isolate do
#     production_domains.each do |domain|
#       set :domain, domain
#       invoke :deploy
#       invoke :restart_thins
#       run!
#     end
#   end
# end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

