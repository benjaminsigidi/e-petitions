namespace :epets do
  
  desc 'Add sysadmin user'
  task :add_sysadmin_user => :environment do
    if AdminUser.find_by_email('admin@example.com').nil?
       admin = AdminUser.new(:first_name => 'Cool', :last_name => 'Admin', :email => 'admin@example.com')
       admin.role = 'sysadmin'
       admin.password = admin.password_confirmation = 'xxxxx'
       admin.save!
     end
  end
  
  desc "Flushes memcached"
  task :flush_memcached => :environment do
    Rails.cache.clear
  end
  
  desc 'Wait for sunspot server to start.'
  task :wait_for_sunspot_to_start => :environment do
    require 'lib/sunspot_server_util'
    port = ENV['port']
    if port.blank? then
      puts 'Specify a port number (port={port number})'
    else
      SunspotServerUtil.wait_for_sunspot_to_start(port)
    end
  end
  
  desc "Email admin users with a list of validated petitions"
  task :admin_email_reminder => :environment do
    EmailReminder.admin_email_reminder
  end
  
  desc "Email threshold users with a list of threshold petitions"
  task :threshold_email_reminder => :environment do
    EmailReminder.threshold_email_reminder
  end

  desc "Special resend of signature email validation"
  task :special_resend_of_signature_email_validation => :environment do
    EmailReminder.special_resend_of_signature_email_validation
  end

  namespace :whenever do
    desc "Update the Primary Server crontab"
    task :update_crontab_primary => :environment do
      Whenever::CommandLine.execute(
        :update => true,
        :set => "environment=#{RAILS_ENV}",
        :identifier => 'Epets_primary_server'
      )
    end
  end
  namespace :jobs do
    desc "Unlock all delayed jobs (to be used after a restart)"
    task :unlock_all => :environment do
      Delayed::Job.update_all("locked_by = NULL, locked_at = NULL")
    end
  end
end  

