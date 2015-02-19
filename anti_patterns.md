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

