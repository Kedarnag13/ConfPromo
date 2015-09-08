# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ConfPromo'
# set :repo_url, 'git@gitlab.qwinixtech.com:repositories/rails/inotary.git'
set :repo_url, 'git@github.com:Qwinix/ConfPromo.git'
set :scm, :git
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :format, :pretty

set :default_env, { :path => "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
set :rbenv_type, :user # or :system, depends on your rbenv setup

set :bundle_gemfile, proc { release_path.join('Gemfile') }
set :bundle_dir, proc  { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, proc  { shared_path.join('bin') }
set :bundle_roles, :all
set :bundle_bins, %w(gem rake rails)

# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :keep_releases, 5

before 'deploy:updated'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), :in => :sequence, :wait => 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), :in => :groups, :limit => 3, :wait => 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
