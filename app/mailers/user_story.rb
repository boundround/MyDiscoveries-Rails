class UserStory < ActionMailer::Base
  default from: current_user.email


  def send_story(user, story_text, attachments = [])
    @user = user
    @story_text = story_text

    attachments.each do |file|
      attachment "application/octet-stream" do |a|
        a.body = file.read
        a.filename = file.orginal_filename
      end unless file.blank?
    end

    mail(to: "donovan@boundround.com",
        subject: "New User Story From " + @user.name ? @user.name : @user.email
        )
  end
end
