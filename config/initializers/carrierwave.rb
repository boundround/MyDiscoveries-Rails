  CarrierWave.configure do |config|

    config.fog_provider = 'fog/aws'                        # required
    config.asset_host = "https://dqgr5tph2zdxx.cloudfront.net"
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AS3_ACCESS_KEY'],                        # required
      aws_secret_access_key: ENV['AS3_SECRET_ACCESS_KEY'],                        # required
      region:                'ap-southeast-2',                  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = ENV['AS3_BUCKET_NAME']                          # required
    config.fog_public     = true                                        # optional, defaults to true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{28.day.to_i}" } # optional, defaults to {}
  end
