[Setting up Syntax Highlighting with markdown](https://github.com/LaunchAcademy/event_horizon/commit/780627f7937cf0445370f10b595840200c0271f3)

## Steps for setting up Markdown in Rails:

**Step 1**: Write tests:

This will need to be changed a little bit for whatever you are trying to render
in markdown, this is a good generic test that can be used as a template though.

```ruby
scenario 'I can view lessons in markdown' do
  lesson = FactoryGirl.create(
    :lesson, body: "## Foo\n\nbar\n\n* item 1\n* item 2")

  visit lesson_path(lesson)

  expect(page).to have_content(lesson.title)
  expect(page).to have_selector("h2", "Foo")
  expect(page).to have_selector("p", "bar")
  expect(page).to have_selector("li", "item 1")
  expect(page).to have_selector("li", "item 2")
end
```

**Step 2**: Add gems to gemfile and build the Markdown renderer and put in in
your lib folder like so:

```ruby
# gemfile

gem 'redcarpet'
gem 'rouge'
```

Then create the Markdown renderer class:

```ruby
# lib/markdown_renderer.rb
require "rouge/plugins/redcarpet"

class Markdown
  def self.render(content)
    renderer.render(content)
  end

  private

  def self.renderer
    Redcarpet::Markdown.new(HighlightingRenderer,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true)
  end

  class HighlightingRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
```

**Step 3**: Create lib initializer and add render methods to ApplicationHelper
like so:

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  # other stuff here

  def render_markdown(content)
    Markdown.render(content).html_safe
  end
end
```

Add initializer
```ruby
# config/initializers/lib_require.rb
require "markdown_renderer"
```

Now restart the server if you havn't already, since whenever you add a file to
the initializers you will need to restart.  You can now use your helpers in the
view to render the markdown like so:

```ruby
# app/views/lessons/show.html.haml
%p= render_markdown(@lesson.body)
```

DONE! This markdown renderer example does not safely render markdown so make
sure to create a sanitized version if thats something important to you.




