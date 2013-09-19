require 'capistrano/ext/multistage'

set :application, "A simple corner"

set :scm, :git
set :repository, "git@github.com:luis-luna-aguilar/a-simple-corner.git"
set :scm_passphrase, ""

set :user, "root"
set :use_sudo, false
set :deploy_to, "/var/www/a_simple_corner"

set :stages, ["production"]
set :default_stage, "production"

set :normalize_asset_timestamps, false

set :current_path, "#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"

set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

set :rvm_gems_path, "/usr/local/rvm/"

set :default_environment, {
  'PATH' => "#{rvm_gems_path}gems/ruby-2.0.0-p195@a_simple_corner/bin:#{rvm_gems_path}gems/ruby-2.0.0-p195@global/bin:#{rvm_gems_path}gems/ruby-2.0.0-p195/bin:#{rvm_gems_path}bin:$PATH",
  'RUBY_VERSION' => 'ruby 2.0.0',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-2.0.0-p195@a_simple_corner',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-2.0.0-p195@a_simple_corner',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-2.0.0-p195@a_simple_corner'
}

after "deploy:symlink", "deploy:extra_symlinking"

namespace :deploy do

  task :start do 
    run "cd #{current_path} && #{unicorn_binary} -E #{rails_env} -c #{unicorn_config} -D"
  end

  task :stop do
    (run "kill `cat #{unicorn_pid}`") rescue true
  end

  task :restart, :roles => :app do
    stop
    start
  end

  task :extra_symlinking, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/application.yml #{current_path}/config/application.yml"
  end

end
