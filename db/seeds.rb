# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = ['Beach', 'Park', 'Animals',
            'Sport', 'Museum', 'Activity',
            'Theme Park', 'Sights', 'Place To Eat',
            'Place To Stay', 'Shopping']

categories.each do |category|
  Category.create(name: category, identifier: category.delete(' ').underscore)
end

ind = 1

cats = [6,6,6,5,5,8,8,10,4,8,8,2,8,6,1,4,6,2,2,2,6,2,1,3,6,3,11,2,11,3,3,
        6,8,6,5,3,8,4,2,6,9,8,1,4,3,6,2,3,5,9,7,7,7,6,9,9,10,3,3,3,6,8,10,
        8,6,8,2,4,2,8,8,9,9,9,9,4,6,2,6,5,8,3,8,5,2,6,5,4,4,10,8,4,9,3,8,
        6,6,6,3,3,3,1,6,8,6,4,8,9,7,7,6,6,1,4,11,4,3,4,9,3,10,10,3,6,6,4,
        3,5,5,3,2,4,8,6,6,8,7,5,11,2,2,6,5,4,6,3,1,4,10,6,7,6,5,11,6,6,10,
        11,10,4,8,6,3,3,3,9,6,4,6,3,5,8,6,6,6,6,10,4,10,3,8,6,4,6,6,6,6,4,
        6,5,6,3,3,7,10,8,6,6,6,6,3,6,6,2,6,10,9,6,2,2,6,4,1,6,4,1,10,1,10,
        6,6,4,6,9,6,4,6,4,6,6,5,1,3,3,3,6,8,6,6,11,6,8,6,6,6,5,11,7,6,10,8,
        2,5,6,6,4,7,3,7,7,7,3,3,7,7,5,3,4,9,4,8,9,8,6,4,2,2]

cats.each do |cat|
  Categorization.create(category_id: cat, place_id: ind)
  ind += 1
end
