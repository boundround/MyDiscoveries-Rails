# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Area.create({ code: "LAX", identifier: "losangeles",
              country: "United States of America",
              display_name: "Los Angeles",
              short_intro: "Los Angeles is super rad",
              description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              latitude: 34.0522342, longitude: -118.2436849,
              address: "Los Angeles, CA, USA" })

p = Photo.create({ title: "LA Skyline", credit: "Donovan Whitworth",
                  area_id: 1, fun_fact: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  sound_sprite: nil})

p["path"] = "LA_Skyline_Mountains.jpg"
p.save

