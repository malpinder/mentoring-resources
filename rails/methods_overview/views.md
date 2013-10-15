Views
=====

Assets
------

Use `stylesheet_link_tag` and `javascript_include_tag` to easily include css & js files into your view.

    <%= stylesheet_link_tag "application" %>
    <%= javascript_include_tag "application" %>


Content panes
-------------

If you need to put something in the head or the footer, but only for a single page, use `content_for`.

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

