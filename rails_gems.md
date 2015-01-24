## Gems that make Rails tick:

**ActiveSupport**: compatibility library, includes methods that change words
from single to plural, or CamelCase to snake_case. Better time/date support than
Ruby standard library.

**ActiveModel**: hooks features into your models.

**ActiveRecord**: Object-Relational Mapper (ORM), maps Ruby objects to your SQL
database.  Makes working with data way easier.

**ActionPack**: does the routing.  Maps incoming URL to controllers and actions.
Passes instance variables between controllers and views.  Can use different
templates like erb or haml.

**ActionMailer**: used to send out email, has text-based templates and not
regular web-page templates.


### Making Rails/Ruby Gems:

One common pattern seen in a lot of gems is the ! at the end of method calls
that will raise an error if not executed properly.  As I studied the slugged gem
today I found how easy it is to implement those methods in my own gems.  Here is
an example that illustrates that very well:

```ruby
def find_using_slug(slug)
  slug = slug.to_s
  value = nil
  value ||= find_by_id(slug.to_i) if slug =~ /\A\d+\Z/
  value ||= with_cached_slug(slug).first
  value ||= find_using_slug_history(slug) if use_slug_history
  value.found_via_slug = slug if value.present?
  value
end

def find_using_slug!(slug)
  find_using_slug(slug) or raise ActiveRecord::RecordNotFound
end
```

Essentially all you're doing is calling the original method (the non-bang
version) and adding an ``or raise ActiveRecord::RecordNotFound`` error if
nothing is returned.







