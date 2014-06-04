CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:           "Rackspace",
    rackspace_username: ENV['RACKSPACE_USERNAME'],
    rackspace_api_key:  ENV['RACKSPACE_KEY'],
    rackspace_region:   :syd
  }
  config.fog_directory = ENV['RACKSPACE_DIRECTORY']
  config.asset_host    = ENV['RACKSPACE_HOST']
end
