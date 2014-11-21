# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://app.boundround.com/"
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/#{ENV['AS3_BUCKET_NAME']}/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  # Add all areas:
  Area.find_each do |area|
    next if area.published_status == 'draft' || area.published_status == 'out'
    add area_path(area), :lastmod => area.updated_at
  end

  # Add all places:
  Place.find_each do |place|
    next if place.subscription_level.downcase == "out" || place.subscription_level.downcase == "draft"
    add place_path(place), :lastmod => place.updated_at
  end
end

SitemapGenerator::Sitemap.ping_search_engines('https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz')

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
