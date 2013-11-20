Has Many
--------

````
class Loan < ActiveRecord::Base
  # attributes:
  #   :id, :business_id, :amount, :term

  has_many :repayments
end

class Repayment < ActiveRecord::Base
  # attributes:
  #   :id, :loan_id, :amount, :paid, :due_date
  belongs_to :loan
end

# Get a loan
Loan.find(582)

# Get the repayments for the loan
repayments = loan.repayments

# Create a new repayment for the loan
loan.create_repayment(amount: 20, due_date: Date.today)

# Get all the repayments that are paid for this loan
loan.repayments.where(paid: true)

# Set (or replace) all the repayments at once
loan.repayments = [ Repayment.new(amount: 20), Repayment.new(amount: 380) ]

````
Saving
------

If the parent record (in this case, loan) is already saved:

the child gets saved as soon as it's added to the collection. Things that don't add it to the collection don't save.
````
# Saves automatically
loan.create_repayment(amount: 50)
loan.repayments << Repayment.new(amount: 50)
loan.repayments = [ Repayment.new(amount: 50) ]

# Does not save automatically
loan.build_repayment(amount: 50)
Repayment.new(loan: loan)
````

If it's not saved, then none of the children are saved. If the loan is saved after they are added, all the records are saved together.

Deleting
--------

By default ActiveRecord will delete the foreign_key from the repayments (in this case, loan_id) but leave the records hanging around, loanless.

This default option is called `dependent: :nullify` and you can set it if you really want to be explicit.

You can set it to destroy all the orphaned records using the option `dependent: :destroy`.
You can set it to delete all the records (avoiding callbacks, validations, and any other checks) using `dependent: :delete_all`.
If you want the loan to never ever be deleted if there are repayments, use `dependent: :restrict_with_exception` to raise an exception, or `restrict_with_error` to stop the save by adding an error to the loan record.
