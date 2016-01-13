class ApiBlog
  attr_accessor :id, :image, :title, :content, :created_at

  def initialize(options)
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

  def self.blog_request(place_param)
    # place_param = Place.display_name.parameterize
    url = "https://corporate.boundround.com/wp-json/wp/v2/posts?filter[cat]=772&filter[tag]=#{place_param}"
    respon = get_request(url)
    results = []
    respon.each_with_index do |json, index|
      blog = ApiBlog.new(:id => nil, :image=> nil, :title=> nil, :content=> nil, :created_at=> nil)
      # blog[index.to_s] = {}
      # debugger
      blog.title = json["title"]["rendered"]
      url_img = json["_links"]["https://api.w.org/featuredmedia"][0]["href"]
      image_url = get_request(url_img)

      # json["content"]["rendered"].split("http://corporate.boundround.com/wp-content/uploads/")[5].split("><img")[0]
      # "2015/09/Sydney-to-Hobart-race.jpg\""
      if !image_url["data"].blank?
        src_img = json["content"]["rendered"].split("http://corporate.boundround.com/wp-content/uploads/")
        img = ""
        # src_img.size.times do |i| #0 , 1, 2, 3, 4
          1.upto(src_img.size/2) do |j| #1 , 2, 3, 4, 5
            arys = []
            0.upto((src_img.size/2)-1) {|i| arys << i }
            # puts src_img[j+arys[j-1]].split("><img")[0]
            img = src_img[j+arys[j-1]].split("><img")[0] rescue next
            break 
          end
          blog.image = "http://corporate.boundround.com/wp-content/uploads/" + img.chop
        # end
      else
        blog.image = image_url["source_url"]
      end
      # blog[index.to_s]["content"] = json["content"]["rendered"]
      blog.id = json["id"]
      blog.created_at = json["date"]
      results << blog
    end

    return results

  end
end