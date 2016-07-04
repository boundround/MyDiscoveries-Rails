  CarrierWave.configure do |config|
    # config.storage = :fog
    # config.fog_credentials = {
    #   provider:           "AWS",
    #   aws_access_key_id: ENV['AS3_ACCESS_KEY'],
    #   aws_secret_access_key:  ENV['AS3_SECRET_ACCESS_KEY'],
    #   region: 'ap-southeast-2'
    # }

    # config.fog_directory = ENV['AS3_BUCKET_NAME']

    # config.asset_host = "https://d1w99recw67lvf.cloudfront.net"
    # config.fog_public = true
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('AS3_BUCKET_NAME')
    config.aws_acl    = 'public-read'

    # Optionally define an asset host for configurations that are fronted by a
    # content host, such as CloudFront.
    config.asset_host = 'https://d1w99recw67lvf.cloudfront.net'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    config.aws_credentials = {
      access_key_id:     ENV.fetch('AS3_ACCESS_KEY'),
      secret_access_key: ENV.fetch('AS3_SECRET_ACCESS_KEY'),
      region:            ENV.fetch('AWS_REGION') # Required
    }
  end
