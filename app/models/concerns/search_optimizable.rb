module SearchOptimizable
  extend ActiveSupport::Concern

  def all_text
    text = Nokogiri::HTML.parse(self.content).xpath("//text()").to_s.split(" ").join(" ").downcase
  end

  def get_keyword_density
    text = all_text
    return 0 if focus_keyword.blank?
    return 0 if text.blank?

    if text.include? focus_keyword.downcase
      calculate_keyword_density
    else
      return 0
    end

  end

  def keyword_count
    return 0 if focus_keyword.blank?
    return 0 if all_text.blank?
    text_array = all_text.split(" ")
    text = text_array.join(" ")
    text.scan(/#{focus_keyword.downcase}/).length
  end

  def word_count
    all_text.split(" ").size
  end

  def calculate_keyword_density
    return 0 if word_count.blank?
    (keyword_count.to_f / word_count)
  end

  def optimum_keyword_density?
    (0.01 < calculate_keyword_density) && (calculate_keyword_density < 0.03)
  end

  def seo_complete_percentage
    percent = 0.0
    percent += 100/8 if focus_keyword.present?
    percent += 100/8 if meta_description.present?
    percent += 100/8 if focus_keyword.present? && (meta_description.present? && meta_description.include?(focus_keyword))
    percent += 100/8 if seo_title.present?
    percent += 100/8 if seo_title.present? && seo_title.include?(focus_keyword)
    percent += 100/8 if word_count > 299
    percent += 100/8 if optimum_keyword_density?
    percent += 100/8 if focus_keyword.present? && slug.gsub("-", " ").include?(focus_keyword)
    percent
  end
end
