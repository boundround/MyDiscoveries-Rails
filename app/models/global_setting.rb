class GlobalSetting
  attr_accessor :guarantee_text

  def initialize(options={})
    @global_guarantee = options[:guarantee_text]
  end

  def save(key)
    Rails.cache.write(key, @global_guarantee)
  end

  def self.find(key)
    Rails.cache.read(key)
  end
end