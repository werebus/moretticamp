namespace :solid_queue do
  desc 'Quiet solid_queue (start graceful termination)'
  task :quiet do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, fetch(:solid_queue_systemd_unit_name)
    end
  end

  desc 'Stop solid_queue (force immediate termination)'
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :kill, '-s', 'SIGQUIT',
              fetch(:solid_queue_systemd_unit_name), raise_on_non_zero_exit: false
    end
  end

  desc 'Start solid_queue'
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, fetch(:solid_queue_systemd_unit_name)
    end
  end

  desc 'Restart solid_queue'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, fetch(:solid_queue_systemd_unit_name)
    end
  end
end
