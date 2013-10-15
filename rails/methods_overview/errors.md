Errors
======

Rails comes with it's own default 500 and 404 error pages. (It's the lovely red text in a red box on a white background.)

You can see these in public/404.html and public/500.html.

On your development machine, any errors bubble up and are shown in the browser along with a backtrace.

On production, Rails will render the 500 error page with a 500 status code.

If ActiveRecord::RecordNotFound or ActionController::RoutingError is raised, it shows a 404 page instead.
