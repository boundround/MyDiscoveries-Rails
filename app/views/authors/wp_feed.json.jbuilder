json.items @authors do |author|
  json.id author.id
  json.name author.name
  json.description author.description
  json.image author.image_url
  json.link author.link
  json.stories_ids author.stories.map { |story| story.id }
  json.email author.users.present? ? author.users.first.email : 'stories@boundround.com'
end