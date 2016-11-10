json.array!(@regions_stories) do |regions_story|
  json.extract! regions_story, :id, :region_id, :story_id
  json.url regions_story_url(regions_story, format: :json)
end
