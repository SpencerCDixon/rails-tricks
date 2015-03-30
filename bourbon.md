## Getting Bourbon Set Up in Rails

Add gems to gemfile:
```ruby
# gemfile

gem 'bourbon'
gem 'neat'
gem 'refills'
```

Change application.css to application.scss:

```ruby
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require foundation_and_overrides
 */

@import 'bourbon';
@import 'neat';
```

Remove all the sprockets and import the new sass libraries.

This example is also using foundation along with Bourbon because it was required
for the app that was being built.  In general you can remove the foundation
overrides as well since they shouldn't be needed if you use Neat for the grid.


