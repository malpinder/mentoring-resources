Has one
-------

has_one is pretty much identical to has_many, except it takes a singular relation name, and it only every returns one record.

````
class Business < ActiveRecord::Base
  # attributes:
  #  :id, :name

  has_one :loan
end

class Loan < ActiveRecord::Base
  # attributes:
  #   :id, :business_id, :amount, :term
  belongs_to :loan
end

# Get a business
business = Business.find(id: 131)

# Get it's loan
loan = business.loan

# Create a new loan for a business
business.create_loan(amount: 4000)
````

More than one in the DB
-----------------------

has_one will only ever return one record, no matter what.

If you bump the old record from the assocation, the old one will be orphaned (or deleted, depending on what you've set as :dependant).

````
business.create_loan(amount: 500)
Loan.count # => 1
business.create_loan(amount: 5000)
Loan.count # => 2
business.loan.count # => 1
Loan.first.business_id # => nil
````
