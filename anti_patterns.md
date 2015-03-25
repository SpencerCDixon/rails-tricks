### Rails Antipatterns

When you create scopes (which are really class methods) in a model the return
value will be a AR proxy object that responds to the normal interface for AR.
One thing you can do to refactor fat models is make a bunch of scopes and then
class methods using those scopes in order to increase readability and only have
1 long SQL statement to the DB.

### Rendering Partials - What Rails does behind the scenes

```ruby
<!-- posts/index.html.erb -->
<% @posts.each do |post|
 <h2> <%= post.title %> </h2>
 <p> <%= post.body %> </p>
<% end %>
```

Can then become:

```ruby
<!-- posts/index.html.erb -->
<% @posts.each do |post|
  <%= render partial: 'post', object: :post %>
<% end %>

<!-- posts/_post.erb -->
<h2> <%= post.title %> </h2>
<p> <%= post.body %> </p>

```

Can then become:
```ruby
<!-- posts/index.html.erb -->
<%= render partial: 'post', collection: @posts %>

<!-- posts/_post.erb -->
<h2> <%= post.title %> </h2>
<p> <%= post.body %> </p>
```

Can then become:
```ruby
<!-- posts/index.html.erb -->
<%= render @posts %>

<!-- posts/_post.erb -->
<h2> <%= post.title %> </h2>
<p> <%= post.body %> </p>

```

## Rails Composition

When models start getting bigger its important to follow SRP and maintain that
each class truly only has one purpose.

For example imagine we have an Order class that has a bunch of little helper
converter methods like this:

```ruby
class Order < ActiveRecord::Base

  def to_xml
    ...
  end

  def to_json
    ...
  end

  def to_csv
    ...
  end

  def to_pdf
    ...
  end
end
```

We could refactor this so Order's have an OrderConverter that maintains the
responsibility of all those smaller helper methods.

```ruby
class Order < ActiveRecord::Base
  def converter
    OrderConverter.new(self)
  end
end

class OrderConverter
  attr_reader :order
  def initialize(order)
    @order = order
  end

  def to_xml
    ...
  end

  def to_json
    ...
  end

  def to_csv
    ...
  end

  def to_pdf
    ...
  end
end
```

Now we could call something like `@order.converter.to_pdf` however this is now
breaking the Law of Demeter.  


Thats nice, but we can take it one step further and allow the Order instances to
delegate those helper method calls directly to their new _composed_ object.  

To fix the Law of Demeter we can use Rails delegation.

```ruby
class Order < ActiveRecord::Base
  delegate :to_xml, :to_json, :to_csv, :to_pdf, to: :converter
  def converter
    OrderConverter.new(self)
  end
end
```
