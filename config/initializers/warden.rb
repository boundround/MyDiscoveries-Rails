Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  if auth.cookies.signed[:guest_token].present?
    if user.is_a?(User)
      Spree::Order.where(guest_token: auth.cookies.signed[:guest_token], user_id: nil).each do |order|
        order.associate_user!(user)
      end
    end
  end
end
