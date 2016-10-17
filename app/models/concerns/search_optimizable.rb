module SearchOptimizable
  extend ActiveSupport::Concern

  def all_text
    text = Nokogiri::HTML.parse(self.content).xpath("//text()").to_s.split(" ").join(" ").downcase
    text = text.xpath("//text()").to_s
  end

  def get_keyword_density
    text = all_text
    return "No Focus Keyword" if focus_keyword.blank?
    return "No Content" if text.blank?

    if text.include? text
      calculate_keyword_density
    else
      return "0"
    end

  end

  def calculate_keyword_density
    text_array = all_text.downcase.split(" ")
    text = text_array.join(" ")
    keyword_multiplier = focus_keyword.split("").size
    numer_of_total_words = text_array.size


  end
end


text = Nokogiri::HTML.parse(s.content).xpath("//text()").to_s.split(" ").join(" ").downcase
