namespace :posts do
  desc "Publish posts with cron on certain time"
  task :publish => :environment do
    # Post.publish_waiting.ready_for_publish.find_each do |post|
    #   post.publish_now!
    # end
    puts "TEST TEST TEST"
  end
end
