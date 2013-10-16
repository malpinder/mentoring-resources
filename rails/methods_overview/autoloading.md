Autoloading
===========

Normally in Ruby if you want the code in a separate file you have the require it:

    require 'basic_account'

    class SpecialAccount < BasicAccount
      ...

Rails has a thing called autoload that means you don't have to do this.

If you call a class that the environment doesn't know about, because you haven't required the file...

    class SpecialAccount < BasicAccount

then Rails will go look for a file in the models directory that is named 'account.rb'. This is why you don't have require calls to all your models littering the controllers and views.

Two caveats:

  - If a file is in the lib directory, it won't be autoloaded. You'll have to require it explicitly or change the autoload paths.
  - If a class is namespaced, it needs to be in a folder corresponding to the namespacing. (This is good practise in general, too).
    So BasicAccount should be /models/basic_account.rb, but Account::Basic should be in models/account/basic.rb
