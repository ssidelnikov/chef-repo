#
# Cookbook Name:: sidekiq
# Recipe:: default
#

applications_root = node[:rails][:applications_root]

node[:active_applications].each do |application, deploy|
  process_name = "sidekiq_#{application}"
  #process_name = "unicorn"
  app_path = "#{applications_root}/#{application}"

  monitrc_file = "/etc/monit/monitrc.d/#{process_name}.conf"
  template monitrc_file do
    source "monitrc.conf.erb"
    owner 'root'
    group 'root'
    mode 0644
    variables(
      :env => deploy[:rails_env],
      :path => app_path,
      :user => deploy[:user] || "deploy",
      :group => deploy[:group],
      :process_name => process_name
    )
  end

  link "/etc/monit/conf.d/#{process_name}.conf" do
    owner 'root'
    group 'root'
    to monitrc_file
  end

  execute "ensure-sidekiq-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-sidekiq" do
    command %Q{
      echo "sleep 20 && monit -g #{process_name} restart all" | at now
    }
  end
end
