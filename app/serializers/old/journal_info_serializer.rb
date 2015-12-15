class JournalInfoSerializer < ActiveModel::Serializer
  attributes :questions


  def questions
    return ["What was the best thing?", "What is your funniest memory?",
      "What did you eat that you loved/didn't like?", "Your Story:", "AA_Rating"]
  end
end
