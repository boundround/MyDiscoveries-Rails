namespace :search_suggestions do
  desc "Generate search suggestions from places"
  task :index => :environment do
    SearchSuggestion.index_places
  end
end
