## Spencer's Rails Guide

Reference:  
*  Geocoding - page 272  
*  Calculation AR methods - page 279  
*  Enum (used for draft, published, archived) - page 291  
*  hstore with Postgres - page 304
*  Passing partials variables - pg 326


# Table of Contents  
*  [Helpers](#helpers)  
*  [Link To](#helpers)  
*  [Nesting Routes](#nesting_routes)  


### Config
Changes to config files require a server restart

### DB Settings
It's best practice to put the database.yml file in .gitignore since different
developers will have different db settings

### Routing
*  The routing system maps URLs to actions
*  Two purposes: maps requests to controller action methods, and it enables the
   dynamic generation of URLs for use as arugments to methods like link_to and
redirect_to
*  home page: root 'welcome#index'
*  routes are called based on priority, first created = first called.
*  just like sinatra, the first route to succeed will get executed. Order _does_
   matter

Two ways to make a route:

```ruby
get 'products/:id', to: 'products#show'
get 'products/:id' => 'products#show'
```

Params such as :id are known as *segment keys*

Explicit call to link_to:
```ruby
link_to 'Products',
controller: 'products',
action: 'show'
id: 1
```

The explicit version isn't used anymore but it's useful to see for understanding
of the named paths.

It's vital to understand link_to doesn't know whether its supplying hard-coded
segment values.  It just hopes that given what it has it will hit a correct
route.

You can redirect routes directly in the routes file:
```ruby
get '/foo', to: redirect('/bar')
```

How to use the .:format
```ruby

def show
  @product = Product.find(params[:id])
  respond_to do |format|
    format.html
    format.json { render json: @product.to_json }
  end
end
```
If it's a normal request the html view will be rendered, if the request has
.json at the end of it then the .json block will be called. 

When using routes that have very long paths like: /items/wood/year/1939
Use something called Route Globbing:
```ruby
get 'items/list/*specs', controller: 'items', action: 'list'

def list
  specs = params[:specs]
end
```

Lets say you have a query for specific items:
```ruby
get 'items/q/*specs', controller: 'items', action: 'query'

def query
  @items = Item.where(Hash[*params[:specs].split('/')])
  if @items.empty?
    flash[:error] = "Can't find items with those properties"
  end
  render :index
end

# To show what this is doing:
spec = "base/books/fiction/dickens"
Hash[*spec.split('/')] # will return: { "base" => "books", "fiction" => "dickens" }
```
The square brackets class method on Hash will convert a one-dimensional array of
key/value pairs into a hash! Super useful to know.  Ruby knowledge is vital to
becoming great rails developer.

#### Named Routes
Named routes are only to make your life easier as a programmer.  Initially it
does make things more confusing until you get the hang of it.

Whenever you name a route in routes.rb a new method called name_url gets created
for you.  Calling the method with passing in the correct parameters will
generate the proper path. Additionally, name_path method gets created as well
which will just generate the relative path **without the protocol and host
components**

You can name a route using the option :as
```ruby
# routes
get 'help' => 'help#index', as: 'help'

# in view
link_to 'Help', help_path # path will go to /help
```

**TIP:**
You can test named routes in the console direction using the special app object
```ruby
rails c
app.help_path
=> "/help"

app.help_url
=> "http://www.example.com/help"
```

When to use _url:

Use ``_url`` when using the ``redirect_to`` method.  The HTTP spec states: you should provide
full URI. However, ``_path`` will also work just fine.

You can hardcode your ``link_to`` but then you will be avoiding the rails
routing system which will hurt you in the future becaues you will have to find
and replace all instances of that route.  For example:
```ruby
link_to 'Help', '/main/help'
```
That will work but won't be very sustainable.

Rails Syntactic Sugar for paths:
```ruby
# routes.rb
get "item/:id" => "items#show", as: "item"

# views
link_to "Auction of #{item.name} ", item_path(id: item.id)

# Can be reduced to:
link_to "Auction of #{item.name} ", item_path(item.id)

# Can be reduced to:
link_to "Auction of #{item.name} ", item_path(item)
```

This same pattern can extend to multiple segment keys.  Its **important** they
are in the correct order though.  Example:

```ruby
# routes
get "auction/:auction_id/item/:id" => "items#show", as: "item"

# views
link_to "Auction of #{item.name}", item_path(auction, item) # important these
are in the correct order)

# Depending on the item and auction ids you would get something like this:
"/auction/4/item/11"
```

Overriding the necessity for the ID in params:

```ruby
# in model
def to_param
  description.parameterize
end
```
``parameterize`` will created a munged version of the params for that object
Munged: stripped of punctuation and joined with hyphens

In order to get that item out of the database properly you would want to create
a munged_description column to ensure uniqueness.

```ruby
Item.where(munged_description: params[:id]).first!
```

#### Scoping Routing Rules

Turn this:
```ruby 
get 'auctions/new' => 'auctions#new'
get 'auctions/edit/:id' => 'auctions#edit'
get 'auctions/pause/:id' => 'auctions#pause'
```

Into:
```ruby
scope controller: :auctions do
  get 'auctions/new' => :new
  get 'auctions/edit/:id' => :edit
  get 'auctions/pause/:id' => :pause
end
```

Dry it up even more:
```ruby
scope path: '/auctions', controller: :auctions do
  get 'new' => :new
  get 'edit/:id' => :edit
  get 'pause/:id' => :pause
end
```

Even more syntactic sugar:
```ruby
scope controller: :auctions do
# becomes
scope :auctions do
# becomes
controller :auctions do
```

#### Path Prefix

```ruby
scope path: '/auctions' do
scope '/auctions/ do

# nested implied prefixed paths
scope :auctions, :archived do

# would scope all routes nested to "/auctions/archived"
```

#### Namespaces
Will bundle module, name prefix, and path prefix settings into one declaration

```ruby
namespace :auctions, :controller => :auctions do
  get 'new' => :new
  get 'edit/:id' => :edit
  post 'pause/:id' => :pause
end
```

**TIP** Search for a custom controllers routes: ``rake routes CONTROLLER=products`` 
Alternatevely go to '/rails/info/routes' when server is running to see all
available routes for your Rails project.

### REST
A resource is a high-level description of the thing you're trying to get hold of
when you submit a request.

Advantages of REST:
*  Convenience and automatic best practices for you
*  A RESTful interface to your applications services for everyone else

Rest allows you to define routes with the same name but with intelligence about
their HTTP verbs. 

Making sure to use correct HTTP Verb:  

1.  The default request method is GET  
2.  In a ``form_tag`` or ``form_for`` call, the POST method will be used  
3.  When you need to, you can specify a request method along with the URL
    generated by the named route for.  

You would need to specify ``method: :delete`` to trigger a destroy action in a
controller

#### Singular vs. Plural  

Why some rest routes are singular and some are plural:  
*  Routes for show, new, edit, and destroy are singular b/c they are being
   performed on a particular resource.  
*  The rest of the routes are plural b/c they deal with collections of related
   resources  

**TIP**: All singular routes require an argument because they need to be able to
figure out the id of the member of the collection referenced.  

**TIP**: ``new`` and ``edit`` are really assistant actions.  All they are
suppose to do is show the user a form as part of the process of creating or
updating a resource.

#### Editing A ``resource``

You can add ``except:`` and ``only: `` to customize a resources calls in your
routes to just have the exact paths you need.  

Singular resources (``resource``) are used when you will only have one of
something your app, for example: ``resource :profile``.  

**TIP**: When using singular resources make sure to remember all _paths will be
singular as well.

#### Nesting Routes

```ruby
resources :auctions do
  resources :bids
end
```

When nesting resouces you are making a promise that you will now give any
link_to's and forms the correct number of paramters.

It's generally a good idea to not nest routes more than 1 layer deep.  This is a
topic that is widely debated in the rails community.  Example of getting around
double nested is to use the ``shallow`` block.

```ruby

resources :auctions do
  resources :bids do
    resources :comments
  end
end

# could be changed to:

resources :auctions do
  resources :bids
end

resources :bids do
  resources :comments
end

resources :comments

# OR it can be dried up to simply be:

resources :auctions, shallow: true do
  resources :bids do
    resources :comments
  end
end
```

Concerns can be used when multiple resources share the same associations like
being able to have comments.  For example:

```ruby
resources :auctions do
  resources :bids
  resources :comments
  resources :image_attachment, only: :index
end

resources :bids do
  resources :comments
end

# This can be dried up and use Concerns like this:

concern :commentable do
  resources :comments
end

concern :image_attachable do
  resources :image_attachments, only: :index
end

resources :auctions, concerns: [:commentable, :image_attachmentable] do
  resources :bids
end

resources :bids, conerns: :commentable
```

In this example it appears to be more code but now you can reuse the concerns in
future routes that will need that feature.

#### Customizing Resource Routes

```ruby
resources :auctions do
  resources :bids do
    member do
      get :retract
    end
  end
end
```

This will add a ``/auctions/3/bids/4/retract`` path that can be used to do
something special.

It will also create a ``link_to`` helper like so:  
``link_to 'Retract', retract_bid_path(auction, bid)``

This will show us the bid that needs to be retracted but in order to actually
retract it we will need a POST not a GET.  To add a POST as well we add it under
the member section like so:  

```ruby
resources :auctions do
  resources :bids do
    member do
      get :retract
      post :retract
    end
  end
end
```

However, if you have more than one member you will want to switch to ``match``
like this:  

```ruby
resources :auctions do
  resources :bids do
    member do
      match :retract, via: [:get, :post]
    end
  end
end
```

This can be even further optimized by passing in ``:member`` as a parameter

```ruby
resources :auctions do
  resources :bids do
    match :retract, via: [:get, :post], on: :member
  end
end
```

Customizing the action names in the route for a different language:
```ruby
resources :projects, path_names: { new: 'nuevo', edit: 'cambiar' }
```
The URL's will change but the names of the generated helper methods do not.  
/projects/nuevo(.:format)   projects#new

#### Mapping to a different controller

```ruby
resources :photos, controller: 'images'
```

#### Routes for New Resources

Rails has a neat syntax for creating routes for new resources:

```ruby
resources :reports do
  new do
    post :preview
  end
end
```
This would give you:  
``preview_new_report POST /reports/new/preview(.:format) reports#preview``

In order to make it work we would change the ``form_for`` to:  
```ruby
form_for(report, url: preview_new_report_path) do |f|
...
f.submit "Preview"
```

#### Respond_to method

Instead of specifiying in each action what it can respond to you can do this:
```ruby
class AuctionsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @auctions = Auction.all
    respond_with(@auctions)
  end
end
```

This will dry up the code for each action.  

### Controllers

**Rack**: abstracts away the handling of HTTP requests and responses into a
single, simple ``call`` method that can be used by anything from a plain Ruby
script all the way to Rails itself.

The ``call`` method should return an array with the status code, a hash of all
headers, and an array of the body.

Much of Action Controller is implemented as Rack middleware modules.

**TIP** use ``rake middleware`` to see which Rack filters are enabled for your
application.

Action Dispatch - dispatches requests, example:
```ruby
get 'foo', to: 'foo#index'

# Has a dispatcher instance associated with it whose call method ends up
executing
FooController.action(:index).call
```

When in doubt, Render.  If Rails can't find an action for a controller it will
assume the action was empty and try to render the view with the appropriate name
before throwing an error.

This means: every action has an implied render command in it like this:
```ruby
def index
  render 'demo/index'
end
```

Great example of convention over configuration.  Rails does this to make the
developers life easier, as long as the developer knows it is going to be
happening

#### Rendering Non-Default Templates
When calling render template: is implied

```ruby
render template: '/products/index.html.haml'

# is equivalent to:
render '/products/index.html.haml'
render 'products/index.html.haml'
render 'products/index.html'
render 'index'
render :index
```

All of those renders will show the index view when called within the products
controller.

You can add a flash to a redirect_to method by:
```ruby
redirect_to post_url(@post), alert: "Post created"
```

**TIP** in Rails 4 you can add custom flash types by doing this:
```ruby
class ApplicationController
  add_flash_types :error
end
```
When you add a flash type a special accessor becomes available to redirect_to
just like :alert and :notice


Sharing of instance variables between controllers and views:  Rails loops
through the controller objects variables and for each one, it creates an
instance variable for the view object with the same name and the same data.

#### Callbacks
Callbacks should be made private or protected so they won't get called as public
actions on your controller

You can setup callbacks with this macro style in top of file:
```ruby
before_action :require_authentication
```

If you want to add callback that called no matter what, the Application
Controller would be the place to put them since all other controllers inherit
from there.

Callbacks can be used on specific actions with the :only or :except options.


### Active Record

*  AR will expect an id column to use as the primary key.

Instead of using :default in migrations it makes more sense to set defaults in
the actual models.  You can override the attributes like this:

Reading:
```ruby
class TimesheetEntry < ActiveRecord::Base
  def category
   read_attribute(:category) || 'n/a'
  end
end
```

Writing:
```ruby
class TimesheetEntry < ActiveRecord::Base
  def message=(txt)
    write_attribute(:message, txt + ' in bed')
  end
end
```

Shortcuts:
```ruby
class TimesheetEntry < ActiveRecord::Base
  def message=(txt)
    self[:message] = txt + ' in bed'
  end

  def category
   self[:category] || 'n/a'
  end
end
```

``#save`` will insert a record in db if necessary or update an existing record
with the same primary key.

``#delete`` uses SQL directly and does not load the AR object.  Thus it is
faster.  ``#destory`` loads the object first and then destroys it, it will
trigger ``before_destroy`` callbacks and dependant associations will be
destroyed as well.  There is a difference between the two!

**Locking**: a term for techniques that prevent concurrent users of an pp from
overwriting each others work.

How to pass in multiple parameters to a where clause:
```ruby

Product.where("name = :name AND sku = :sku AND created_at > :date", 
              name: "Space Toilet", sku: 80808, date: '2009-01-01')
```

Order is defaulted to ascending:

```ruby
Timesheet.order(:created_at) # will be ascending

# Rails 4 added feature to do desending:
Timesheet.order(created_at: :desc)
```

Pagination can be implemented with ``#limit`` and ``#offest``

```ruby
Timesheet.limit(10).offset(10) # will return the second set of 10 rows
```
Extending a module into all Models:

```ruby
module Pagination
  def page(number)
  end
end

scope = Model.all.extending(Pagination)
scope.page(params[:page])
```

Preventing N + 1 Queries:
```ruby

# First degree associations
users = Users.where(login: "mack").includes(:billable_weeks)

# Second degree associations
users = Users.where(login: "mack").includes(:billable_weeks)
```

#### Awesome Custom Validators:

```ruby
class EmailValidator < ActiveRecord::Validator
  def validate()
    email_field = options[:attr]
    record.errors[email_field] << 'is not valid' unless
      record.send(email_field) =~ /\A(^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  end
end

class Account < ActiveRecord::Base
  validates_with EmailValidator, attr: :email
end
```

Overriding custom validation messages:
```ruby
class Account < ActiveRecord::Base
  validates_uniqueness_of :uesrname, message: "is already taken"
end
```

Using Scopes:
```ruby
class Timesheet < ActiveRecord::Base
  scope :submitted, -> { where(submitted: true) }
end

Timesheet.submitted
# Will return array of all submitted timesheets
```

Instead of using scope you can also create a class method instead:
```ruby
def self.delinquent
  where('timesheets_updated_at < ?', 1.week.ago)
end

User.delinquent
# returns delinquent users
```

Passing a scope a parameter:
```ruby
scope :newer_than, ->(date) { where('start_date > >', date) }
```

Scopes can be chained together for reuse within scope definitions themselves:
```ruby
class Timesheet < ActiveRecord::Base
  scope :submitted, -> { where(submitted: true) }
  scope :underutilized, -> { submitted.where('total_hours < 40') }
```

Scopes are automatically available in has_many relationships


#### Callbacks
If you return false (not nil) from a callback method then AR halts the execution
chain.

Preventing records from being deleted:
```ruby
class Account < ActiveRecord::Base
  before_destroy do
    self.update_attribute(:deleted_at, Time.current)
    false # this will halt the execution chain
  end

  ...
end
```

Open-Closed Principle: Write code that is open for extension but closed for
modification.

#### Single Table Inheritance
In order to activate STI all you need to do is include a type:string column in
the parent class. 

#### Polymorphic Associations
```ruby
class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
end
```

NOTE: There is no ``Commentable`` class in our application.  It's named that way
to describe the interface of objects that will be associated with comments.

```ruby
class Timesheet < ActiveRecord::Base
  has_many :comments, as: :commentable
end

class BillableWeek < ActiveRecord::Base
  has_many :comments, as: :commentable
end
```

We specifiy the polymorphism with the ``as:`` 

Migration for comments:
```ruby
create table :comments do |t|
  t.text :body
  t.integer :commentable
  t.string :commentable_type
end
```

There is a shortcut for your migrations to make it even easier given by AR API
```ruby
t.references :commentable, polymorphic: true
```

Enum can be used as a state machine inside rails.

```ruby
class Post < ActiveRecord::Base
  enum status: %i(draft published archived)
  ...
end

create_table :posts do |t|
  t.integer :status, default: 0
end

Post.new.status
#  => "draft"

post.published!
post.published?
# => true

# See page 291 for more example

```

Refactoring into Modules for common behavior:

```ruby
module Commentable
  extend ActiveSupport::Concern
  included do
    has_many :comments, as: :commentable
  end
end

class Timesheet < ActiveRecord::Base
  include Commentable
end

# The include will now work since we extended activesupport concern.  If we
hadn't dont that the has_many class method would of been called in the incorrect
scope.  It would of been called in the scope of module Commentable and not the
class Timesheet
```

**TIP** ActiveModel::Conversion and ActiveModel::Naming should be extended into non
AR::Base models so that the view helpers can still determine paths, routes, and
naming.

**UUID**: universally unique identifier - a 128-bit value that is unlikely to be
generated twice.

To set a column as a UUID:
```ruby
add_column :table_name, :unique_identifier, :uuid
```

### Views

Folders after app/views/ are linked up to specific controllers, the files inside
those folders are linked to specific actions inside that controller

#### Additional Yields

```ruby
# in applicaiton.html.haml

%body
  .left.sidebar
    = yield :left
  .content
    = yield 
  .right.sidebar
    = yield :right
```

Then to add content to one of the other yields you simply call ``content_for``
in the view passing in the proper symbol.

```ruby
- content_for :left do
  %h2 Navigation
  ....

- content_for :right do
  %h2 Help
  ....
```

In addition to sidebars it's a good idea to ``yield :head`` in case you have any
page specific head data you want in, ex: Facebook Open Graph.

Conditional output:

```ruby
- if show_subtitle?
  %h2= article.subtitle
```

Shorter one-liner version:  
```ruby
%h2= article.subtitle if show_subtitle?
```
Problem is if it returns nil then there will be empty ``h2`` tags on the page

Taking advantage of controller and action names in your CSS:
```ruby

%body{ class: "#{controller.controller_name} #{controller.action_name}" }

# Body will look like:
<body class="timesheets index">
```

Haml has a helper method to do the above:
```ruby
%body{ class: page_class }
```

With that added CSS you can customize things like background images per page
using some sass fun:
```ruby
body {
  .timesheets .header {
    background: image1
  }

  .expense_reports .header {
    background: image2
  }
}
```

#### Flashes
Because flashes are used so commonly you can add them to the ``redirect_to``
method to save time:
```ruby
redirect_to root_path, notice: "Welcome, you are signed in"
```

There are also special accessors for notice and alert since they are used so
much:
```ruby
def create
  if @user.save
    flash.notice = "Welcome"
  else
    flash.alert = "Login invalid"
  end
end
```

Knowing that we can display flash messages in our layouts like so:
```ruby

%body
  - if flash.notice
    .notice= flash.notice
  - if flash.alert
    .notice.alert= flash.alert

  = yield
```
 
#### Partials
In older versions of rails ``render :partial`` was the syntax.  Now you can pass
in a string to render the correct partials. ``render 'partial'``

Partial template names must begin with an underscore.  Leave the underscore OUT
when referring to them.

Generally best practice to encapsulate a partial inside a well-defined div or
semantically significant container.  Will help with understanding how it will
render and with CSS later on.

When creating partials that will be used in multiple views, stick them in a
shared folder and render like this:

```ruby
# app/views/shared/_captcha.html.haml

# app/views/users/new.html.haml
 ...
 = render 'shared/captcha'
 ...
```

#### Rendering Collections
**TIP**: Providing fallback to prevent nil iteration:
```ruby
= render(entries) || "No entries exist"
```

Ordering a rendered collection with the ``_counter`` method:
```ruby
= div_for(entry) do
  "#{entry_counter}: #{entry.description} 
#{distance_of_time_in_words_to_now entry.created_at} ago"
```

### Helpers

#### AssetTagHelper
Methods for generating HTML that links views to assets such as images, js,
stylesheets, and feeds.

Custom Favicon:
```ruby
favicon_link_tag '/myicon.ico'
```

Setting up path to javascript files:
```ruby

javascript_include_tag 'xml1hr'
# => src="/assets/xmlhr.js"

# Setting explicit pathes:
javascript_include_tag 'common', '/elsewhere/cools'
# => src="/assets/common.js"
# => src="/elswhere/cools.js"
```
These rules all also apply to ``stylessheet_link_tag``

Image Paths:
```ruby
image_path("edit.png") # => /assets/edit.png
image_path("icons/edit.png") # => /images/icons/edit.png
image_path("/icons/edit.png") # => /icons/edit.png
```

Image Tags:
```ruby
image_tag('icon.png') # => src="/assets/icon.png"
image_tag('/photos/icon.gif') # => src="/photos/icon.gif"
```
See page 341 for more asset tag/path helper methods

Dynamically decide whether layout will have columns:

```ruby
%body{class: content_for?(:right_col) ? 'one-column' : 'two-column'
  = yield
  = yield :right_col
```

#### DateHelper
**TIP**: ``distance_of_time_in_words_to_now`` has been aliased to ``time_ago_in_words``

One use case:
```ruby
%strong= comment.user.name
%br
%small= "#{time_ago_in_words(review.created)at)} ago"
```

#### FormHelper
Can be used with classes other than Active Record models, again in order to do
that you would want to mixin ActiveModel::Model to your class.

```ruby
= f.text_field :first_name

# gets expanded to:

= text_field :person, :first_name
```

If you want resulting params hash posted to your controller to be named based on
something other than the class name of the object you pass to ``form_for``, you
can pass an symbol in:

```ruby
= form_for person, as: :client do |F|

= f.text_field :first_name

# gets expanded to:
= text_field :client, :first_name, object: person
```

Options:
``:url``: The url the form is submitted to. May pass a named route directly  
``:namespace``: A namspace that will be prefixed with an underscore on the
generated HTML id of the form.  
``:html``: Optional HTML attributes for the form tag.  
``:builder``: Optional form builder class  

**TIP**: The preferred way to use ``form_for`` is to rely on automated resource
identification, which will use conventions and named routes instead of manually
configuring the ``:url`` option.

Creating nested forms - see page 363
All other helpers can be found after nested forms

#### FormOptionsHelper
Select:

```ruby
= select(:post, :person_id, Person.all.collect { |p| [ p.name, p.id ] },
  { include_blank: true }
```
That will create a drop down with all the People's names and id's, the first
dropdown will be blank because of ``include_blank: true``

#### NumberHelper
``number_to_percentage(number, options = {})``
``number_to_phone``

#### TextHelpers
``excerpt(text, phrase, options={})``  
``highlight(text, phrases, options={})``  
``pluralize(count, singular, plural=nil)``  
``truncate(text, options={}, &block)``  if text is longer than the length option
the text will be truncated to the length specified and the last three characters
will be replaced with :omission (default: ...)  
``word_wrap(text, options={})`` wraps text into lines no longer than the
:line_width option.  

#### UrlHelper
``button_to(name, options, html_options, &block)``: If no :method is given it
will default to a post. 

Example:
```ruby
button_to "Delete Image", { action: "delete", id: @image.id },
  method: :delete, data: { confirm: "Are you sure?" }

# => <form method="post" action="/images/delete/1" class="button_to">
```

``current_page?(options)``: returns true if the current request URI was
generated by the given options.

Example:
(assuming we're currently rendering /shop/checkout)
```ruby

current_page?(action: 'process')
# => false

current_page?(action: 'checkout') # controller is implied
# => true

current_page?(controller: 'shop', action: 'checkout')
# => true
```

``link_to(name, options, html_options, &block)``: Creates a link tag of the
given name using a URL created by the set of options.

Options:  
``method:`` **symbol** specify an alternative HTTP verb other than GET.
``remote:`` **true** allows unobtrusive JS driver to make an Ajax request to the
URL instead of following a link.
``confirm:`` 'Question?' JS

``link_to_if``:  creates a link tag using the same options as link_to but the
first parameter is a condition.

``link_to_unless``:  creates a link tag using the same options as link_to but the
first parameter is a condition.

Linking back unless current:
```ruby
link_to_unless_current("Comment", { controller: 'comments', action: 'new' }) do
  link_to("Go back", posts_path)
end
```
``mail_to(email_address, name = nil, html_options = {}, &block)``

**TIP**: If you pass the magic symbol, ``:back``, to any method that uses
url_for under the covers, the user will be returned back to the last requested
page.


#### Writing Custom Helpers
As you develop your app when you start to see a lot of duplication in the views,
that is a great opportunity to extract it out into helper methods.  Helper
methods are basically custom, app-level, API for your view code.

```ruby
def page_title(name)
  content_for(:title) { name }
  content_tag('h1', name)
end

# application layout
%html
  %head
    %title= yield :title
```

Default photo view helper
```ruby
def photo_for(user, size=:thumb)
  if user.profile_photo
    src = user.profile_photo.public_filename(size)
  else
    src = 'user_placeholder.png'
  end
  link_to(image_tag(src), user_path(user))
end
```

**TIP**: In order to create custom view helpers you need to create a directory
called ``helpers`` inside the app directory.  The universal helper will be
called ``application_helper.rb''

Here is an example of a generic helper:
```ruby
module ApplicationHelper
  def some_method
    ...
  end
end
```

#### Adding strong params to devise:
```ruby
class ApplicationController < ActionController::Base
  before_action :devise_permitted_paramters, if: :devise_controller?

  protected

  def devise_permitted_paramters
    devise_paramter_sanitizer.for(:sign_up) << :phone_number
  end
end
```

Adding multiple paramters:
```ruby
class ApplicationController < ActionController::Base
  before_action :devise_permitted_paramters, if: :devise_controller?

  protected

  def devise_permitted_paramters
    devise_paramter_sanitizer.for(:sign_in) { |user| user.permit(:email,
:password, :remember_me, :username) }
  end
end
```

Faster testing with Devise:
```ruby
# spec/support/devise.rb
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

# this will create some helper methods like sign_in and sign_out
```


Displaying errors in HAML:
```ruby
= form_for [@assignment, @submission] do |f|
  - if @submission.errors.any?
    .errors
      %p The solution couldn't be submitted.
      %ul
        - @submission.errors.full_messages.each do |message|
          %li= message

  = f.label :body, "Solution"
  = f.text_area :body

  = f.submit "Submit"
```


## Difference between AR#update and #update_attributes

When you use #update you can change multiple objects by passing in an array of
object ids and corresponding hashes of what to update.  #update_attribute is
used to just update a single attribute on a single object and finally
#update_attributes is used to update multiple attributes of a _single_ object.






























































































