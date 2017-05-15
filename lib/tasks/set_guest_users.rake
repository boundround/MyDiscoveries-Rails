namespace :users do
  desc "Set guest users"
  task set_guests: :environment do
    User.where(encrypted_password: '').update_all(guest: true)
  end
end
