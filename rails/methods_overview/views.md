Views
=====

Partials
--------

Rails Guide: http://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
Docs: http://api.rubyonrails.org/classes/ActionView/PartialRenderer.html

A partial lives in the views folder for whatever it's for, and begins with an underscore e.g. 'views/users/_form.html.erb'.

When rendering a partial, omit the underscore. If it's in the same folder as the view you're calling it from, you don't have to specify the folder name either.

    <%= render "form" %>
    <%= render "shared/menu" %>

You can pass variables to the partial using locals, or via the :object option (which gives you a variable with the same name as the partial)

    <%= render partial: "customer", locals: {customer: @new_customer} %>
    <%= render partial: "customer", object: @new_customer %>

If you have an instance of a model, you can just pass that straight to render & it'll try to render a partial with the name of the class:

    <%= render @customer %>  # Tries to render /views/customers/_customer.html.erb & passes the @customer variable to it

If you have a collection of instances, you can render all of them by passing the collection to render.

    <%= render @customers %>  # Renders /views/customers/_customer.html.erb once for each customer.

Assets
------

Use `stylesheet_link_tag` and `javascript_include_tag` to easily include css & js files into your view.

    <%= stylesheet_link_tag "application" %>
    <%= javascript_include_tag "application" %>


Content panes
-------------

If you need to put something in the head or the footer, but not the same thing everywhere, use `content_for`.

In your layout:

    <body>
      <%= yield %>
    </body>
    <footer>
      <%= yield :footer %>
    </footer>

In your view:

    <p>I'm rendered in the body, just like normal!</p>

    <%= content_for :footer do %>
      I'm only in the footer!
    <% end %>


HTML Generators
---------------

Docs: http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html

Use `link_to` to generate an <a> tag. The first argument is the text, the second is the url. You can use strings, path helpers, or if the object has a resourceful-route just the object.

    link_to "Your profile", '/profile'
    link_to "Your profile", profile_path(@profile)
    link_to "Your profile", @profile # but only if it's an instance of Profile, and the routes has resource :profile in it

`link_to_unless_current` will generate a link unless it's a link to to the page you're currently on, in which case it generates a span with some text. (see current_page? further down.)

Use `button_to` to generate a form containing a single button, that will by default POST to the given url.

Use `image_tag` to generate an <img> tag.

Use `content_tag` to generate a tag of any kind. (It's mostly useful in helper methods in helpers, presenters, or other odd places.)

    content_tag :div, class: "boxy" do
      link_to "Things", things_path
    end

Helpers
-------

Docs: http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html
http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html

`current_page?` will return true or false if a given url is the current page.

    current_page?('/shop/checkout')
    # => true
    current_page?(checkout_path)
    # => true


Use `number_to_currency` to give a float value the correct number of decimal places & currency symbol.

    number_to_currency(123.456, unit: "£") # => £123.45

`distance_of_time_in_words` displays the vague time between two times in natural language. `time_ago_in_words` is the same but the second time is set to now.

    distance_of_time_in_words(1.hour.ago, 110.minutes.ago)  # => about 1 hour
    time_ago_in_words(3.years.ago)  # => about 3 years

`pluralize` will output the number and the correctly pluralised word. Remember to pass the singular form!

    pluralize "person", 1 #=> "1 person"
    pluralize "person", 2 #=> "2 people"
    pluralize "sheep", 4  #=> "4 sheep"

`truncate` will truncate a string to the desired length (30 by default, '...' by default.)

