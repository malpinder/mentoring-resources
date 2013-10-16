Scaffolds & Generators
======================

Rails has lots of generators that run from the command line which can build parts of your application for you, so you don't have to write all the boilerplate.

Scaffold
--------

`rails generate scaffold NAME field:type other_field:type` will generate a whole load of stuff for you.

The first argument, name should be the name of your model, in the singular and lowercase. Then follows a list of the fields your model should have and their types.

    rails generate scaffold user first_name:string date_of_birth:date

This generates a whole bunch of things:

      invoke  active_record
      create    db/migrate/20131016103527_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      invoke  resource_route
       route    resources :users
      invoke  scaffold_controller
      create    app/controllers/users_controller.rb
      invoke    erb
      create      app/views/users
      create      app/views/users/index.html.erb
      create      app/views/users/edit.html.erb
      create      app/views/users/show.html.erb
      create      app/views/users/new.html.erb
      create      app/views/users/_form.html.erb
      invoke    rspec
      create      spec/controllers/users_controller_spec.rb
      create      spec/views/users/edit.html.erb_spec.rb
      create      spec/views/users/index.html.erb_spec.rb
      create      spec/views/users/new.html.erb_spec.rb
      create      spec/views/users/show.html.erb_spec.rb
      create      spec/routing/users_routing_spec.rb
      invoke      rspec
      create        spec/requests/users_spec.rb
      invoke    helper
      create      app/helpers/users_helper.rb
      invoke      rspec
      create        spec/helpers/users_helper_spec.rb
      invoke  assets
      invoke    js
      create      app/assets/javascripts/users.js
      invoke    scss
      create      app/assets/stylesheets/users.css.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.css.scss

From the top:

  - a migration file that creates the table, with the desired attributes & the created_at and updated_at timestamps
  - a user model class
  - a `resources :user` entry in the routes.rb file
  - a users controller class, with all the resourceful actions (index, show, new, create, edit, update, destroy)
  - an index view, which has a table of records
  - a show view, which lists all the record's attributes
  - a _form partial, which contains a form_for with all the attributes
  - an edit & new view, which use the _form partial
  - a helper file, which is empty
  - a JS file, which is also empty
  - a stylesheet, again, empty
  - and tests for these classes & files.

You can get individual bits of this using other generators:

`rails generate migration MIGRATION_NAME` will generate a timestamped migration file, without anything in it.

`rails generate model MODEL_NAME field:type other_field:type` will generate both the model class, a spec, and a migration to create the table & fields.

`rails generate controller NAME action other_action` will generate a controller with the specified actions & a view for each one (but no form partial, and no list of attributes).

There are other scaffolds but these are the commonest ones. You can run `rails generate` to see a list, and `rails generate $whatever_generator` without any arguments to see help for that generator.

If you use a scaffold, you can have a (very) basic application ready to run in just a few seconds.
