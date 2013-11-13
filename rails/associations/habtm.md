Has and belongs to many
-----------------------

has_and_belongs_to_many is a way of describing relations where neither record can hold the foreign key.

They're generally less common that has_many :through.

````
class Borrower < ActiveRecord::Base
  # attributes
  #  :id, :email
  has_and_belongs_to_many :permissions
end

class Permissions < ActiveRecord::Base
  # attributes
  #  :id, :name
  has_and_belongs_to_many :borrowers
end
````

Notice that neither has a permissions_id or borrower_id. HABTM relies on a join table that isn't represented by a model, and which doesn't have an id column of it's own.

You'll need to create the join table in a migration by yourself. It should be named as a combination of the two classes.
````
    create_table :borrower_permissions do |t|
      t.integer :borrower_id
      t.integer :permissions_id
    end
````

Because the join table isn't modeled, you shouldn't put any extra attributes on there. It's just the two ids. If you need something else on the join record, use has_many :through instead.

Saving & Deleting
-----------------

Rails will create & delete records from the join table whenever needed. It won't follow that delete through to the related record.

````
borrower = Borrower.create
permission = Permission.create

borrower.permissions << permission # inserts into the join table

borrower.permissions = [] # delets from the join table

Permissions.count # => 1
````

