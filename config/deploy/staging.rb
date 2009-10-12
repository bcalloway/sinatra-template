# Based on the original DreamHost deploy.rb recipe
#
# This deploy recipe will deploy a project from a GitHub repo to a Dreamhost server
#
# GitHub settings #######################################################################################
default_run_options[:pty] = true
set :repository,  "git@github.com:USERNAME/PROJECTNAME.git" #GitHub clone URL
set :scm, "git"
set :scm_passphrase, "" # This is the passphrase for the ssh key on the server deployed to
set :branch, "master"
set :scm_verbose, true

# Dreamhost Settings #####################################################################################
set :user, 'USERNAME' # Dreamhost username
set :domain, 'SERVER.dreamhost.com'  # Dreamhost servername where your account is located 
set :project, 'PROJECTNAME'  # Your application as its called in the repository
set :application, 'subdomain.yourdomain.com'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

set :keep_releases, 1

# Don't change this stuff, but you may want to set shared files at the end of the file ##################
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache
 
# roles (servers)
role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

# additional settings
#default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
 
# Optional tasks ##########################################################################################
# for use with shared files (e.g. config files)
#after "deploy:update_code" do
#  run "ln -s #{shared_path}/database.yml #{release_path}/config/"
#  run "ln -s #{shared_path}/configuration.php #{release_path}/"
#end