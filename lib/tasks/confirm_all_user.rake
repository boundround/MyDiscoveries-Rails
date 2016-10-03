namespace :users do
  desc "Confirm email for all user"
  task :confirm_all => :environment do
    User.all.each do |user|
      next if user.confirmed?
      user.confirm
    end
  end
end
