require 'dalli'
# dc.set('abc', 123)
# value = dc.get('abc')

class ApiBlog
  OPTS = { :namespace => "api_v1", :compress => true }
  CLIENT = Dalli::Client.new('localhost:11211', OPTS)

  attr_accessor :id, :image, :title, :content, :created_at

  def initialize(options={})
    @id = options[:id]
    @title = options[:title]
    @content = options[:content]
    @image = options[:image]
    @created_at = options[:created_at]
  end

  def self.get_request(url)
    url_parse = URI.parse(url)
    response = Net::HTTP.get_response(url_parse)
    JSON.parse response.body
  end

  def self.parse_image(image_url, json)
    # json["content"]["rendered"].split("http://corporate.boundround.com/wp-content/uploads/")[5].split("><img")[0]
    if !image_url["data"].blank?
      src_img = json["content"]["rendered"].split("http://corporate.boundround.com/wp-content/uploads/")
      img = ""
        1.upto(src_img.size/2) do |j|
          arys = []
          0.upto((src_img.size/2)-1) {|i| arys << i }
          img = src_img[j+arys[j-1]].split("><img")[0] rescue next
          break
        end
       image = "http://corporate.boundround.com/wp-content/uploads/" + img.chop
       # return img.blank? ? "" : image
       ""
    else
      image_url["source_url"]
    end
  end

  def self.blog_request(place_param)
    url = "https://corporate.boundround.com/wp-json/wp/v2/posts?filter[cat]=772&filter[tag]=#{place_param}"
    respon = get_request(url)
    results = []
    has_image = nil
    respon.each_with_index do |json, index|
      has_image = json["_links"]["https://api.w.org/featuredmedia"]
      if has_image
        image = json["_links"]["https://api.w.org/featuredmedia"][0]["href"]
      else
        image = ""
      end
      blog = ApiBlog.new(:title => json["title"]["rendered"], :content => json["content"]["rendered"],
      :image => image, :id=>json["id"], :created_at=>json["date"])
      if has_image
        image_url = get_request(blog.image)
        blog.image = parse_image(image_url, json)
      end
      results << blog
    end
    # set_cached_blogs(results, place_param)
    return results
  end

  def self.set_cached_blogs(blogs, place_slug)
    CLIENT.set(place_slug, blogs)
  end

  def self.get_cached_blogs(place_slug, model)
    Rails.cache.fetch(model+"_"+place_slug, :expires_in => 1.day) do
      blog_request(place_slug)
    end
  end

  def self.clear_cached_blogs(place_slug)
    Rails.cache.delete(place_slug)
  end

  # for palce
  def self.find_blog_id(id, place_slug)
    arys = get_cached_blogs(place_slug, 'place')
    arys.find{|obj|obj.id.eql?(id)}
  end

  # for primary category
  def self.find_blog_primary_cat(id, primary_cat)
    arys = get_cached_blogs(primary_cat, 'primary_cat')
    arys.find{|obj|obj.id.eql?(id)}
  end

  # for primary category
  def self.find_blog_sub_cat(id, place_slug)
    arys = get_cached_blogs(place_slug, 'subcat')
    arys.find{|obj|obj.id.eql?(id)}
  end

  # def self.find_blog_cat(cat)
  #   arys = get_cached_blogs(place_slug)

  # end
end
