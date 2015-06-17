bin/rails g controller programs

# Generator Code

bin/rails generate model Program place:references name:string description:text  yearlevelnotes:text cost:string programpath:string heroimagepath:string duration:string times:text booknowpath:string contact:string

#e.g. Download map, etc...
bin/rails generate model Webresources program:references caption:string path:string

#Add tag attributes to model
#  acts_as_taggable # Alias for acts_as_taggable_on :tags
#  acts_as_taggable_on :programsubjects, :programyearlevels, :programactivities

# Access tags for context using 
# ActsAsTaggableOn::Tagging.includes(:tag).where(context: *MYCONTEXT*).uniq.pluck(:id, :name)


###If we implement as models###
##e.g. Download map, etc...
#bin/rails generate model Resource Program caption:string path:string

##e.g. Geography, etc...
#bin/rails generate model Subject Program caption:string  
##join table
#bin/rails generate model Subjectization Program Subject

##e.g. Excursion, etc...
#bin/rails generate model Activity Program caption:string  
##join table
#bin/rails generate model Subjectization Program Subject


RESULTS: 
create  app/controllers/programs_controller.rb
invoke  erb
create    app/views/programs
invoke  helper
create    app/helpers/programs_helper.rb
invoke  assets
invoke    coffee
create      app/assets/javascripts/programs.js.coffee
invoke    scss
create      app/assets/stylesheets/programs.css.scss

create    db/migrate/20150610174625_create_programs.rb
create    app/models/program.rb

create    db/migrate/20150610174820_create_webresources.rb
create    app/models/webresource.rb