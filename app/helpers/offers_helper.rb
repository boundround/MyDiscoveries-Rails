module OffersHelper
  def main_offer_photo_url(offer)
    photo = offer.photos.where(hero: true).first.presence || offer.photos.first.presence
    url   = photo.try(:path_url, :large) || ActionController::Base.helpers.asset_path('generic-hero.jpg')
    title = photo.try(:title)

    { url: url, title: title }
  end

  # converts duration from microseconds to days
  def duration_in_days(duration)
    duration / (1.day * 1000)
  end
end
