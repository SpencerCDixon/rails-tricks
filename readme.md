## Spencer's Rails Guide

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

Use ``_url`` when using the ``redirect_to`` method.  The HTTP spec (you should provide
full URI) However, ``_path`` will also work just fine.














































