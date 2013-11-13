Belongs to
--------

Almost every time you write a has_one or has_many in one class, you'll add a belongs_to on another.

belongs_to means the table holds the foreign_key, or, the key identifying the records 'owner'.

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
````

If you don't have the foreign key (or if it's named something other than what Rails expects), you'll either get a somewhat cryptic error (when your database doesn't have the column it's been asked to search on) or you'll get nil.

Saving
------

If the parent isn't saved when the child record is saved, then the parent gets saved first, then the child.

````
loan = Loan.new
repayment = Repayment.new(loan: loan)
repayment.save!
repayment.loan_id # => 1
````
The has_* definition on the parent will affect saving too; go take a look at those pages.

Deleting
--------
If you delete a record that belongs_to another, nothing special happens.
Again, the has_* definition on the parent will affect deleting.

Blank foreign keys
------------------

If a belongs_to record has no foreign key saved, it's called 'orphaned'. There's nothing nessessarily bad about this; sometimes the system will want orphaned records and sometimes not.
