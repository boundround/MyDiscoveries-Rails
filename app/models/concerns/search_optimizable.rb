module SearchOptimizable
  extend ActiveSupport::Concern

  def all_text
    text = Nokogiri::HTML.parse(self.content).xpath("//text()").to_s.split(" ").join(" ").downcase
  end

  def get_keyword_density
    text = all_text
    return "No Focus Keyword" if focus_keyword.blank?
    return "No Content" if text.blank?

    if text.include? focus_keyword.downcase
      calculate_keyword_density
    else
      return "0"
    end

  end

  def keyword_count
    text_array = all_text.split(" ")
    text = text_array.join(" ")
    text.scan(/#{focus_keyword.downcase}/).length
  end

  def word_count
    all_text.split(" ").size
  end

  def calculate_keyword_density
    (keyword_count.to_f / word_count)
  end
end


# text = Nokogiri::HTML.parse(s.content).xpath("//text()").to_s.split(" ").join(" ").downcase
