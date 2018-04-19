json.items @stories do |story|
  json.id story.id
  json.title story.title
  json.abstractText story.teaser
  json.author story.author_name
  json.date story.date_fields
  json.body story.content_for_feed
  json.link story.links
end