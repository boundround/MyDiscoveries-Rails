require 'dalli'

class GlobalSetting
  OPTS = { :namespace => "settings_v1", :compress => true }
  CLIENT = Dalli::Client.new('localhost:11211', OPTS)

  attr_accessor :guarantee_text

  def initialize(options={})
    @global_guarantee = options[:guarantee_text]
  end

  def save(key)
    begin
	  CLIENT.set(key, @global_guarantee)
	  true
	rescue
	  false
	end
  end

  def self.find(key)
    CLIENT.get(key)
  end
end