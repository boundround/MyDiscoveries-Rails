# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.boundround.com/"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/#{ENV['AS3_BUCKET_NAME']}/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do

  # Add all places:
  Place.find_each do |place|
    if place.status.downcase == "live"
      puts
      video_array = Array.new
      photo_array = Array.new
      place.photos.find_each do |photo|
        puts photo.path
#        a_photo = { :loc => photo.path, :title => photo.title, :caption => photo.caption, :license => photo.credit, :geo_location => }
        a_photo = { :loc => photo.path_url, :title => photo.title, :caption => photo.caption }
        photo_array.push(a_photo)
      end
      place.videos.find_each do |video|
        puts video.vimeo_thumbnail
#        a_video = { :thumbnail => video.vimeo_thumbnail, :content_loc => "https://vimeo.com/"+video.vimeo_id, :tags => :title => TBD, :description => TBD, }
        a_video = { :thumbnail_loc => video.vimeo_thumbnail, :title => place.display_name, :description => ActionView::Base.full_sanitizer.sanitize(place.description), :content_loc => "https://vimeo.com/"+video.vimeo_id.to_s }
        video_array.push(a_video)
      end

      add place_path(place), :lastmod => place.updated_at, :images => photo_array, :videos => video_array
    end
  end

  # Add all countries:
  Country.find_each do |country|
    if country.published_status == 'live'
      add country_path(country), :lastmod => country.updated_at
    end
  end

  Post.find_each do |post|
    if post.status == 'live'
      add post_path(post), :lastmod => post.updated_at
    end
  end

  Story.find_each do |story|
    if story.status == 'live'
      add story_path(story), :lastmod => story.updated_at
    end
  end

end


#SitemapGenerator::Sitemap.ping_search_engines('https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz')
#SitemapGenerator::Sitemap.ping_search_engines('https://s3-ap-southeast-2.amazonaws.com/#{ENV['AS3_BUCKET_NAME']}/sitemaps/sitemap.xml.gz')
SitemapGenerator::Sitemap.ping_search_engines('https://www.boundround.com/sitemap')

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
