__orginally posted on https://coderwall.com/p/kqb3xq/rails-4-how-to-partials-ajax-dead-easy__

Consider the basic following scenario...

A view with two columns:
one with links of Category model instances
the other empty but eager to show all the Item instances belonging to each Category.
And you want to show all of that without reloading the page. I had never played much
with partials in Rails, but they are really really convenient.

So I have my index method
items_controller.rb
```ruby
def index
    @items = Item.all
    @categories = Category.all
end
```

For the sake of brevity, I will simplify the views. This way you can also understand the idea and apply it to your own views.

The index view contains two render calls
```erb
<!-- items/index.html.erb -->
<div class="grid">
  <%= render 'sidebar_menu' %>

  <%= render partial: 'item_grid', locals: { items: @items} %>
</div>
```

The category links in the sidebar_menu partial are something like the following:
```erb
<%= link_to cat.name, fetch_items_path(:cat_id => cat.id), :remote => true %>
```
fetch_items_path is the route that leads to our custom javascript method, which will be described next.

config/routes.rb
```ruby
get "/fetch_items" => 'items#from_category', as: 'fetch_items'
```

For more info on how to build custom routes, check Rails amazing documentation.

**The :remote => true is the most important part here, it allows the whole Ajax business in the first place.**

The item_grid partial looks like:
```erb
<div>
  <div id="items_grid" >
    <%= render partial: 'items_list', locals: {items: items}  %>
  </div>
</div>
```
The subpartial items_list just renders a list of div boxes to show our Item instances.
```erb
<% items.each do |item| %>
  <div class="item_box">
    ...
  </div>
<% end %>
```
Now we need the method that will do the AJAX magic. For simplicity you could have something like this:

items_controller.rb
```ruby
def from_category
    @selected = Item.where(:category_id => params[:cat_id])
    respond_to do |format|
        format.js
    end
end
```
Notice the type of format, there's no html view because we don't need it.
We're going through JS. Therefore, we need to create a javascript file,
which will repopulate the div in the second column.

//views/items/from_category.js.erb
```js
    $("#items_grid").html("<%= escape_javascript(render partial: 'items_list', locals: { items: @selected } ) %>");
```
Let's look at this line with care. I'm rendering the same partial I was rendering in items#index,
and the local variable for the partial is now the array of Item instances that match a given category.
The difference is that I'm doing this through AJAX, so there's no need to reload the entire page.
