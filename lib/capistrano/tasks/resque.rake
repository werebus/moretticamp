namespace :resque do
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, 'resque.target'
      execute :sudo, :systemctl, :start, 'resque.target'
    end
  end
end
