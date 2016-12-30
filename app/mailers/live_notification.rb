class LiveNotification < ActionMailer::Base
  helper :application
  default from: "website@boundround.com"

  def photo_notification(photo)

    @photo = photo
    @user = photo.user

    mail(to: @user.email, subject: "Your photo on Bound Round is now publicly viewable")
  end

  def story_notification(story)
    @story = story
    @user = story.user

    mail(to: @user.email, subject: "Your story on Bound Round is now publicly viewable")
  end

  def review_notification(review)
    @review = review
    @user = review.user

    mail(to: @user.email, subject: "Your review on Bound Round is now publicly viewable")
  end

  def notification(place, user)
    @place = place
    @user = user
    photo = draw_small_background(@place)

    merge_vars = {
      "PLACENAME" => @place.display_name,
      "PLACEPATH" => place_url(place),
      "HEROPHOTO" => photo
    }

    body = mandrill_template("you-ve-been-published-code", merge_vars)
    subject = "You Have Been Published in Bound Round!"

    send_mail(@user.email, subject, body)

  end

  def draw_small_background(place)
    if place.photos.blank? && place.user_photos.blank?
      if place.categories.blank?
        "https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_sights.jpg"
      else
        "https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_" + place.categories[0].identifier + ".jpg"
      end
    else
      if place.photos.find_by(hero: true)
        place.photos.find_by(hero: true).path_url(:small)
      elsif place.user_photos.find_by(hero: true)
        place.user_photos.find_by(hero: true).path_url(:small)
      else
        if place.photos.blank?
          if place.categories.blank?
            "https://d1w99recw67lvf.cloudfront.net/category_icons/large_generic_sights.jpg"
          else
            "https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_" + place.categories[0].identifier + ".jpg"
          end
        else
          place.photos.reorder(:priority).first.path_url(:small)
        end
      end
    end
  end

end
