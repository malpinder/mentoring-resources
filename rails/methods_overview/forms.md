Forms
=====

Broadly speaking, there are two kinds of form helpers in Rails: `form_tag` and `form_for`.

`form_tag` and the *_tag helpers will generate the HTML for a form & inputs for you, but require lots of arguments passed to them.

`form_for` and the helpers that don't end in tag do a lot more for you, but they need a Rails-model-style object to work.

form_for
--------

`form_for` takes an awful lot of options & is very flexible, but the first argument must be an instance of a model. If the model has a resource entry in the routes file, then the url doesn't need to be specified.

    # Noisy, long version
    <%= form_for @user, as: :user, url: user_path(@user), method: :put, html: { class: "edit_user", id: "edit_user_45" } do |f| %>
      ...
    <% end %>

    # Simpler version
    <%= form_for @user do |f| %>
      ...
    <% end %>

`form_for` takes a block, and gives you a form builder object to use in that block. This form builder object wraps the instance, allowing the form input helpers to pick up on existing values and error messages automatically.

    <%= form_for @user do |f| %>
      # If the user record has a first name of 'Clive', this field will be pre-populated with 'Clive'.
      <%= f.text_field :first_name %>
    <% end %>

If you're using `form_for` input helpers, you must call them on the form builder object, or you'll get really unhelpful and strange error messages.

Input helpers
-------------

Assuming these are all for the @user form above...

    f.label(:first_name)
    f.text_field(:first_name)
    f.text_area(:bio)
    f.email_field(:email)
    f.password_field(:password)
    f.date_field(:birth_date)
    f.radio_button(:subscribed, true)

`check_box` has an odd gotcha; it generates a hidden field with the 'off' value, since unchecked checkboxes aren't sent to the server.

    f.check_box :odd # => <input name="user[odd]" type="hidden" value="0" /> \n <input type="checkbox" id="user_odd" name="user[odd]" value="1" />

The `select` helper takes a collection of possible options for it's second argument, in the form of an array of arrays. (It does NOT use options_for_select, that's a different thing.)

    f.select(:boss, [ ["Clive", 1], ["Jill", 2], ["Sam", 3] ])
    f.select(:boss, Boss.all.collect {|p| [ p.name, p.id ]} )

You can also use `collection_select` which generates the array of arrays for you.

    f.collection_select(:boss, Boss.all, :name, :id)

form_tag
--------

`form_tag` doesn't take an object and doesn't provide a form builder object.


CSRF token
----------

Both form_for and form_tag add a hidden_field with Rails's CSRF token in it. If you're writing a form yourself, you'll need to add the token in using `form_authenticity_token`.
