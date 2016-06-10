module CountriesPostsHelper
  def array_countries_posts_ids(countries_posts)
    country_ids = []
    countries_posts.each do |countries_post|
      if !countries_post.country_id.blank?
        country = Country.find(countries_post.country_id)
        country_ids.push({country_id: country.id, country_name: country.display_name})
      end
    end
    country_ids.to_json
  end
end
