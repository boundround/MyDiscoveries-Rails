class LiveNotification < BaseMandrillMailer
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
    # headers['X-MC-MergeVars'] = {"placename" => @place.display_name, "placepath" => "https://app.boundround.com".concat(Rails.application.class.routes.url_helpers.place_path(@place)) }
    # headers['X-MC-Template'] = {"template_name" => "you-ve-been-published-code"}

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
    if place.photos.blank?
      if place.categories.blank?
        "https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_sights.jpg"
      else
        '"https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_' + place.categories[0].identifier + '.jpg"'
      end
    else
      place.photos.find_by(priority: 1) ? place.photos.find_by(priority: 1).path_url(:small) : place.photos.first.path_url(:small)
    end
  end

end
