## Debugging Asset Pipeline

*  Check to see whether or not there are assets precompiled already, if so you
    probably need to delete those so it will re-compile them.  
*   When using sprockets check for require_tree, it will make it so all the css
    files get included in a random order which might create issues.  
*  Deploying to Heroku, check to see when you deploy the asset precompilation
    process occurs, if not, check your public/assets folder.  


### Rails Asset Pipeline Clinic

**Assets:** JavaScript, CSS, and other static files we need to properly render
our pages.

Solves:
*  Allows you to nest JS and CSS files in subdirectories
*  No longer need to specify the exact order to include files for third party
   libraries like Bootstrap or Foundation
*  Compresses all our assets so they get served to the browser faster
*  Consolidate CSS and JS files into one file so there are less HTTP requests
   made by the browser, improving page load speed.
*  Allow us to use preprocessors like Sass or Coffee Script. 
*  Enables caching to further increase page speeds and will re cache assets when
   changes are made.


#### Three Places To Store Assets:

app/assets - file specific to current project  
lib/assets - files for internal libraries  
vendor/assets - files for external libraries  

#### Manifest Files

app/assets/javascripts/application.js  
app/assets/stylesheets/application.css  

The manifest files specify where to find other files to load in and in which
order to load them.  

In order to add to manifest you need there to be a comment in the beginning of
the line and an equals sign.  

```javascript
//= require foo   # single line comment

/*
 * 
 *
 *= require foo    # multi line comment
*/
```

#### Directive In Manifest File

= require_self:  Inserts content of the file itself (after directives).  
= require_directory:  Loads all files of the same format in the specified
directory in an alphabetical order.  
= require_tree: Just like require_directory but it also recursively requires all
files in subdirectories.  

**Note**: Directives are loaded in the order they appear unless you use
require_tree in which case there is no guarantee of the order in which the files
will be included

#### Search Pathes

Can be edited with ``config.assets.paths << Rails.root.join('app', 'flash',
'assets')``  

All standard places are added in search paths.  To add fonts you could:
``app/assets/fonts`` folder since it's under the ``app/assets`` it will be
included.  Or you can target files in subdirectories by using a relative path:  

```ruby
// This will load the app/assets/javascripts/library/foo.js
//= require 'library/foo'
```

**Note**: You could put CSS files in JS and JS in CSS folder and everything
would work fine, people would just be annoyed at you.

#### File Extensions

Get compiled in the order they are given:
``products.css.sass.erb`` will run the file through the ERb engine, then sass,
then deliver a css file.

#### Helpers

`` <%= stylesheet_link_tag "application" %>``  
`` <%= javascript_include_tag "application" %>``  

You can pass in different manifest files other than application to these helpers

``image_tag`` knows to search in /app/assets/images

Sass Helper:
```ruby
header {
  background-image: image-url('header-photo.png')
}
```

