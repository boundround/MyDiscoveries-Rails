# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.mydiscoveries.com.au/"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/#{ENV['AS3_BUCKET_NAME']}/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AS3_ACCESS_KEY'],
  aws_secret_access_key: ENV['AS3_SECRET_ACCESS_KEY'],
  fog_directory: ENV['AS3_BUCKET_NAME'],
  fog_region: ENV['AWS_REGION']
)
#TODO this carrierwave uploader using SitemapGenerator gem is broken

SitemapGenerator::Sitemap.create do

  # Add all places:
  Place.active.each do |place|
    add place_path(place),
      lastmod: place.updated_at,
      changefreq: 'monthly',
      priority: 0.9,
      mobile: true
  end

  Region.all.each do |region|
    add region_path(region),
      lastmod: region.updated_at,
      changefreq: 'monthly',
      priority: 0.5
  end

  Spree::Product.active.each do |product|
    add offer_path(product),
      lastmod: product.updated_at,
      changefreq: 'daily',
      priority: 1.0,
      mobile: true
  end

  Story.active.each do |story|
    add story_path(story),
      lastmod: story.updated_at,
      changefreq: 'daily',
      priority: 1.0,
      mobile: true
  end
end


#SitemapGenerator::Sitemap.ping_search_engines('https://s3-ap-southeast-2.amazonaws.com/brwebproduction/sitemaps/sitemap.xml.gz')
#SitemapGenerator::Sitemap.ping_search_engines('https://s3-ap-southeast-2.amazonaws.com/#{ENV['AS3_BUCKET_NAME']}/sitemaps/sitemap.xml.gz')
SitemapGenerator::Sitemap.ping_search_engines('https://www.mydiscoveries.com.au/sitemap')

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
