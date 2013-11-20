Models without associations
----------------------------

````
class Business < ActiveRecord::Base
  # attributes:
  #  :id, :name
end

class Loan < ActiveRecord::Base
  # attributes:
  #   :id, :business_id, :amount, :term
end

class Repayment < ActiveRecord::Base
  # attributes:
  #   :id, :loan_id, :amount, :due_date
end

# Get a business
business = Business.find(id: 131)

# Get it's loan
loan = Loan.where(business_id: business.id).first

# Get the repayments for the loan
repayments = Repayments.where(loan_id: loan.id)

# Create a new loan for a business
Loan.create(business_id: business.id, amount: 4000)

````

There's a lot of features the associations give you that you'd have to do yourself.

````
# Before creating a new loan, need to delete the old one:
Loan.where(business_id: business.id).limit(1).first.destroy
Loan.create(business_id: business.id, amount: 4000)

# Or caching the business record & loan record on each other
class Business < ActiveRecord::Base
  attr_accessor :loan
end

class Loan < ActiveRecord::Base
  attr_accessor :business
end

loan = Loan.where(business_id: business.id).limit(1).first

business.loan = loan
loan.business = business
````
