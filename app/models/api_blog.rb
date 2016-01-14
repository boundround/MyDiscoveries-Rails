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
       return img.blank? ? "" : image
    else
      image = image_url["source_url"]
    end
  end

  def self.blog_request(place_param)
    url = "https://corporate.boundround.com/wp-json/wp/v2/posts?filter[cat]=772&filter[tag]=#{place_param}"
    respon = get_request(url)
    results = []
    respon.each_with_index do |json, index|
      blog = ApiBlog.new(:title => json["title"]["rendered"], :content => json["content"]["rendered"],
      :image => json["_links"]["https://api.w.org/featuredmedia"][0]["href"], :id=>json["id"], :created_at=>json["date"])
      image_url = get_request(url_img)
      blog.image = parse_image(image_url, json)
      results << blog
    end
    set_cached_blogs(results, place_param)
    return results
  end

  def self.set_cached_blogs(blogs, place_slug)
    CLIENT.set(place_slug, blogs)
  end

  def self.get_cached_blogs(place_slug)
    CLIENT.get(place_slug) || blog_request(place_slug)
  end

  def self.clear_cached_blogs(place_slug)
    CLIENT.set(place_slug, nil)
  end

  def self.find_blog_id(id, place_slug)
    arys = get_cached_blogs(place_slug)
    arys.find{|obj|obj.id.eql?(id)}
  end
end