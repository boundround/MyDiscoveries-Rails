namespace :weekly_ucg do
  desc "Generate weekly email with UCG update"
  task :send_ucg_update => :environment do
    UcgUpdate.send_update.deliver
  end
end
