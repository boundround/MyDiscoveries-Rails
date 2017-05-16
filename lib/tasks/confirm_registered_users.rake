namespace :users do
  desc "Confirm email for all registered user"
  task confirm: :environment do
    User.where.not(encrypted_password: '').each do |user|
      next if user.confirmed?
      user.confirm
    end
  end
end
