Has_* :through
-------

has_one :through and has_many :through is a way of leap-frogging a model to get to that model's associations.

Usually the pattern is to promote a 'join table' to a model, with it's own id and attributes:
````
class Loan < ActiveRecord::Base
  # attributes:
  #   :id, :amount, :term
  has_many :repayments
  has_many :lenders, through: :repayments
end

class Repayment < ActiveRecord::Base
  # attributes:
  #   :id, :amount, :due_date, :loan_id, :lender_id
  belongs_to :loan
  belongs_to :lender
end

class Lender < ActiveRecord::Base
  # attributes:
  #   :id, :name
  has_many :repayments
  has_many :loans, through: :repayments
end

````

or to aggregate relations onto a parent class:

````
class Borrower < ActiveRecord::Base
  # attributes
  #  :id, :email
  has_one :business
  has_many :loans, through: :business
end

class Business < ActiveRecord::Base
  # attributes
  #   :id, :borrower_id, :name
  belongs_to :borrower
  has_many :loans
end

class Loan < ActiveRecord::Base
  # attributes:
  #   :id, :business_id, :amount, :term
  belongs_to :business
end

````

You can only use :through with an association that already exists on the model.

Otherwise, it acts mostly the same as a standard has_one or has_many relation.
