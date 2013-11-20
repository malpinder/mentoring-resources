SELECT

Select is how you say what you want a query to return. * means 'all columns'.
Most SQL statements you'll write will begin with a SELECT. (We tend not to do INSERTS by hand.)

SELECTing only a few columns can be useful when querying in the console, since the results can be quite large otherwise.

`SELECT * from loan;`
`SELECT id, auction_id, amount FROM loan;`

You can also alias columns to different names using AS:

`SELECT id AS loan_id, auction_id, amount FROM loan;`

and do sums:

`SELECT id, amount, term, amount/term FROM loan;`

In ActiveRecord, most queries will trigger a SELECT statement and build ActiveRecord objects using the results.
By default, AR will use * and return all columns from the table. (It also specifies namespaces and uses quotes etc that you don't need to worry about normally).
To override the default 'go get everything', use the `select` method.

`Loan.select([:id, :auction_id, :amount])`
  # SELECT id, auction_id, amount FROM "loan"

You'll get an ordinary-looking AR object, but it won't have the unselected attributes on it. If you try and get them you'll get an error.
````
loan = Loan.select(:id).first
loan.id
 # => 17936 
loan.auction_id
 # => ActiveModel::MissingAttributeError: missing attribute: auction_id
````

  COUNT
    Count is something you use in a select query. It counts up all the rows that aren't null and returns the total. (It does NOT sum. Usually you use it to find how many rows are in a table, or things like 'how many loans don't have any audio').

    `SELECT COUNT(*) FROM loan;`
    `SELECT COUNT(audio) FROM loan;`

    You can do this in AR using `count` instead of `first` or `all`.

    `Loan.count`
      # SELECT COUNT(*) FROM "loan"
    `Loan.count(:audio)`
      # SELECT COUNT(audio) FROM "loan"

  DISTINCT
    Distinct is also something you pass to select. You must give it at least one column; it'll return only unique values for that column or combination of columns.

    `SELECT DISTINCT(broker_fee) FROM loan;`
    `SELECT DISTINCT(broker_fee, term) FROM loan;`

    Like `count`, use `distinct` in place of `first` or `all`, but you need to pass the desired columns to `select` first.

    `Loan.select(:broker_fee).distinct.all`
    # SELECT DISTINCT broker_fee FROM "loans"

    In Rails 4 this returns model instances, but in Rails 3 (i.e. FCA) it'll return an Arel::Nodes object which is considerably less helpful.

WHERE

WHERE lets you filter to only return some rows in the DB.

`SELECT * FROM loan WHERE id = 509`

You can chain filters together using AND and OR, which work like you'd expect.

`SELECT COUNT(*) FROM loan WHERE offer_sent = true AND term = 48;`
`SELECT id FROM loan WHERE broker_fee = 1.50 OR amount = 10000;`

In AR you build up a WHERE query using `where`. `where` can take either a hash:
`Loan.where(id: 509)`
  # SELECT "public"."loan".* FROM "public"."loan" WHERE "public"."loan"."id" = 509
`Loan.where(offer_sent: true, term: 48)`

or a string
`Loan.where("id = 509")`

or an array containing a string and then values to put into a string. You can use either ? or :symbols as placeholders.
`Loan.where("id = ?", params[:loan])`
`Loan.where("broker_fee = :broker_fee OR amount = :amount", broker_fee: params[:broker_fee], amount: params[:amount])`

Never interpolate directly into the string, or you risk introducing a security vulnerability.

Weirdly, if you're using a hash, none of the values can be symbols. (They must be strings, numbers, booleans etc.)

  =, !=
    Straightforward equality, but it doesn't work for NULL. (It'll always returns 0 rows.)

    = is what gets used by AR queries most of the time.
      `Loan.where(id: 509)`
        # SELECT "loan".* FROM "loan" WHERE "loan"."id" = 509

    You can't use != in AR without writing it out.
      `Loan.where("loan_type_id != ?", 5)`
        # SELECT "loan".* FROM "loan" WHERE (loan_type_id != 5)

  IS, IS NOT
    IS is mostly used to check if a column is NULL.

    `SELECT COUNT(*) FROM loan WHERE auction_id IS NULL;`
    `SELECT COUNT(*) FROM loan WHERE auction_id IS NOT NULL;`

  <, <=, >, >=
    Range checkers are also pretty straightforward.
    `SELECT COUNT(*) FROM loan WHERE amount < 10000;`
    `SELECT * FROM loan WHERE offer_sent_on >= '21/11/2013';`

  BETWEEN
    Between does what you think it does. It's usually used for dates, and it's inclusive.

    `SELECT * FROM loan WHERE offer_sent_on BETWEEN '19/11/2013' AND '21/11/2013';`

    You can use BETWEEN in AR hashes by using a Range as the value.
    `Loan.where(offer_sent_on: (1.week.ago..Date.today))`
    # SELECT loan".* FROM loan" WHERE (loan"."offer_sent_on" BETWEEN '2013-11-11 12:51:56.468973' AND '2013-11-18 12:51:56.469213')

  IN, NOT IN
    Also known as a subset query, it returns any records where the column in question is in the given set.

    `SELECT * FROM loan WHERE id IN(509, 510)`
    `SELECT * FROM loan WHERE broker_fee NOT IN(0.00, 1.00);`

    You can use IN (but not NOT IN) in AR hashes by using an array as the value.
    `Loan.where(id: [509,510])`
      # SELECT"loan".* FROM "loan" WHERE "loan"."id" IN (509, 510)

  LIKE
    LIKE does fuzzy matching on strings. It's really quite slow, which is why we have things like ElasticSeach and Sphinx.
    Like queries use the % character as a 'wildcard' matcher.

    `SELECT * FROM loan WHERE what_for LIKE '%turbine%';`

  TL;DR
    If you're using hash arguments in AR queries (the commonest case), you can only use =, BETWEEN and IN.
    Otherwise you'll have to write it out as a string.

ORDER

  Order lets you specify the order of results. You pass in a column and an optional direction (`ASC` or `DESC`; it's ASC by default), and separate multiple orders with a comma. (You can only order on columns that are in the SELECT clause.)

  `SELECT id, purpose, fee FROM loan WHERE auction_id IS NOT NULL ORDER BY fee DESC;`
  `SELECT id, fee FROM loan ORDER BY fee, id DESC;`

  In AR you specify an order clause using `order`, which takes either a column name or a hash of column & direction.
  `Loan.where(broker_fee: 1).order(:fee)`
    # SELECT "loan".* FROM "loan" WHERE loan"."broker_fee" = 1 ORDER BY "loans"."fee" ASC
  `Loan.order(:fee, id: :desc)`
    # SELECT loan".* FROM "loan" ORDER BY "loan"."fee" ASC, "loan"."id" DESC

  In Rails 3 (i.e. FCA) you can't use hashes for order arguments: you need to provide strings if you want to change the direction.
  `Loan.order(:fee, "id DESC")`
    # SELECT loan".* FROM "loan" ORDER BY fee, id DESC

LIMIT, OFFSET

LIMIT cuts off the number of rows returned. (It stops any further rows being selected at all, so it can make queries faster.)

`SELECT id, purpose FROM loan LIMIT 10;`

You can do limits in AR using `limit`
`Loan.limit(10)`
  # SELECT "loan".* FROM "loan" LIMIT 10

OFFSET is almost always used alongside LIMIT in order to 'batch' or 'page' results. It specifies the number of rows to 'ignore' before selecting.
`SELECT id, purpose FROM loan LIMIT 10 OFFSET 30;`

You can do limits in AR using `offset`
`Loan.limit(10).offset(30)`
  # SELECT "loan".* FROM "loan" LIMIT 10 OFFSET 30

Most pagination works by using limit and offset to retrieve 'pages' of results.

JOIN

Joins are a bit tricky to understand but they are very powerful tools. JOIN allow you to 'join' together the rows in two separate tables, so that each 'row' in the select query represents the combination of data.

(When you are SELECTing from multiple tables, you'll need to specify the table and the column if it's ambigious.)

Every join requires you to specify the table to join, and which values connect the two together.

`SELECT loan.id, business.id FROM loan JOIN business ON loan.business_id = business.id LIMIT 10;`

The table you select FROM is called the 'left' table. The table you JOIN is called the 'right' table.

Each 'row' of data returned is whatever you'd selected from each table's columns. Using * will select all the data from both tables, linked up.
`SELECT * FROM loan JOIN business ON loan.business_id = business.id LIMIT 1;`

In AR, joins are done using `joins`, which can take either a string of the entire JOIN clause, or a symbol as a shorthand for INNER.

`Loan.joins("INNER JOIN business ON business.id = loan.business_id").limit(10)`
  # SELECT "loan".* FROM "loan" INNER JOIN business ON business.id = loan.business_id LIMIT 10

  INNER

  If you don't specify otherwise, every join is an INNER JOIN. That means rows will only be selected if there is an matching entry in BOTH left and right tables. (Or to put it another way, every row must contain both columns as specified in the ON statement.)

  For instance, in the example above, rows are only chosen from the loans table if they have a business_id, and businesses are only chosen if there is a loan with a matching business id.

  In AR, if you pass a symbol to `joins`, it'll run an INNER JOIN.
  `Loan.joins(:business).limit(10)`
    # SELECT "loan".* FROM "loan" INNER JOIN "business" ON "business"."id" ="loan"."business_id" LIMIT 10

  OUTER

    An OUTER join will select rows from a table even if the columns in the ON statement are nil or don't match.

    `SELECT loan.id, business.id FROM loan OUTER JOIN business ON loan.business_id = business.id LIMIT 10;`

    This will return loans without a business_id, and businesses without a matching loan.

  FULL OUTER

GROUP
  HAVING

EXPLAIN
