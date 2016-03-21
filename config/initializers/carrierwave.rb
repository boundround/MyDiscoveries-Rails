
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:           "AWS",
      aws_access_key_id: ENV['AS3_ACCESS_KEY'],
      aws_secret_access_key:  ENV['AS3_SECRET_ACCESS_KEY'],
      region: 'ap-southeast-2'
    }

    config.fog_directory = ENV['AS3_BUCKET_NAME']

    config.asset_host = "https://d1w99recw67lvf.cloudfront.net"
    config.fog_public = true
  end
