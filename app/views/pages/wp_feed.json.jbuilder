json.pages @pages do |page|
  json.id page.id
  json.title page.title
  json.body page.content
end