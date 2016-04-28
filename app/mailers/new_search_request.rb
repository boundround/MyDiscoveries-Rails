class NewSearchRequest < ActionMailer::Base

 def notification(name, from, term)
    @email = "info@boundround.com"
    @name = name
    @from = from
    @term = term

    mail(to: @email, subject: "New Search Request Term ")
  end

end