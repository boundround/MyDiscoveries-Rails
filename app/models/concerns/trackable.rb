module Trackable
  extend ActiveSupport::Concern

  def track_event(category, action, label = nil)
    push_to_google_analytics('event', ec: category, ea: action, el: label)
  end

  private
  def push_to_google_analytics(event_type, options)
    Net::HTTP.get_response URI 'http://www.google-analytics.com/collect?' + {
      v:   1, # Google Analytics Version
      tid: GA.tracker,
      cid: '555', # Client ID (555 = Anonymous)
      t:   event_type
    }.merge(options).to_query #if Rails.env.production?
  end


  # category = "User - added "
  # action   = "Added"
  # label    = "#{current_user.user_name} has been added"

  # track_event(category, action, label)

end