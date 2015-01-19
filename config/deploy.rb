set :application, 'vmp-shortener'
set :repo_url, 'git@git.vmp.ru:general/vmp-shortener.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/opt/www/vmp-shortener'
set :scm, :git

set :deploy_via, :remote_cache

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp vendor/bundle public/assets public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

def remote_file_exists?(path)
  results = []

  invoke_command("if [ -e '#{path}' ]; then echo -n 'true'; fi") do |ch, stream, out|
    results << (out == 'true')
  end

  results.all?
end

namespace :unicorn do
  pid_path = "#{release_path}/tmp/pids"
  unicorn_pid = "#{pid_path}/unicorn.pid"

  def run_unicorn
    execute "#{fetch(:bundle_binstubs)}/unicorn", "-c #{release_path}/config/unicorn.rb -D -E #{fetch(:stage)}"
  end

  desc 'Start unicorn'
  task :start do
    on roles(:app) do
      run_unicorn
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-QUIT `cat #{unicorn_pid}`"
      end
    end
  end

  desc 'Force stop unicorn (kill -9)'
  task :force_stop do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-9 `cat #{unicorn_pid}`"
        execute :rm, unicorn_pid
      end
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles(:app) do
      if test "[ -f #{unicorn_pid} ]"
        execute :kill, "-USR2 `cat #{unicorn_pid}`"
      else
        run_unicorn
      end
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do    
      
    end
  end

  before :finishing, :create_tmp do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :rake, 'tmp:create'
      end
    end
  end
  
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, 'exec', 'rake', 'tmp:clear'
      end
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'unicorn:restart'

end
