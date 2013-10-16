Pluralisation
=============

The letter s is the lifetime curse of Rails developers.

DB tables are PLURAL, since they hold multiple records.

    # db/migrate/xxx_create_people.rb
    class CreatePeople < ActiveRecord::Migration
      def self.up
        create_table :people do |t|
          ...

Models are SINGULAR, since each instance represents a single model.

    # models/person.rb
    class Person < ActiveRecord::Base

Controllers are PLURAL, since they control lots of different instances.

    #controllers/people_controller.rb
    class PeopleController < ApplicationController

View folders are plural, to match the controller.
