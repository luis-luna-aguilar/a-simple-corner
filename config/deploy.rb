require 'capistrano/ext/multistage'

set :application, "A simple corner"

set :scm, :git
set :repository, "git@github.com:luis-luna-aguilar/a-simple-corner.git"
set :scm_passphrase, ""

set :user, "root"
set :use_sudo, false

set :stages, ["production"]
set :default_stage, "production"

set :normalize_asset_timestamps, false

after "deploy", "deploy:extra_symlinking"

namespace :deploy do

  task :extra_symlinking, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/application.yml #{current_path}/config/application.yml"
  end

end