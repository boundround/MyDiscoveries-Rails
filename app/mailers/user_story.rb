class UserStory < ActionMailer::Base
  default from: 'user_stories@boundround.com'


  def send_story(user_email, user_name = '', story_text, location, files)
    @user_name = user_name
    @user_email = user_email
    @story_text = story_text
    @location = location

    files.each do |file|
      if file
        mail.attachments[file.original_filename] = File.read(file.tempfile)
      end
    end

    mail(to: "stories@boundround.com",
        subject: "New User Story From " + @user_name
        )
  end
end
