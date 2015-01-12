# Rails 4 Test Perscriptions

"Test-driven dev enables you to design your software continuously and in small
steps, allowing the design to respond to the changes int he code."

**Perscription 1:** Use the TDD process to create and adjust your code's design
in small, incremental steps.

**Perscription 2:** If it is difficult to write tests for a feature, strongly
consider the possibility that the underlying code needs to be changed.

"TDD is a software-dev technique masquerading as a code-verification tool."

"A test that requires a bunch of tricky setup often indicates a problem in the
underlying code."

**TIP**: in rails 4.1 the test database is automatically maintained wh en the
schema.rb file changes.

**TIP**: the ``spec_helper.rb`` file contains general RSpec settings while the
``rails_helper.rb`` file (which requires the spec_helper file) loads the Rails
environment and contains settings that depend on Rails.  The reason why it's set
up this way is to make it easier to write specs that do not load Rails.

``rspec-rails`` gem adds a Rake file that changes default rake task to run RSpec
instead of Minitest. It will also set up generators properly for any future
models you generate.

**Perscription 3:**: Initializing objects is a good starting place for a TDD
process.  Another good approach is to use the test to design what you want a
successful interactino of the feature to look like.


### Beginning The Project
First test to create a Project object that will eventually have tasks
```ruby
# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project do
  it "considers a project with no tasks to be done" do
    project = Project.new
    expect(project.done?).to be_truthy
  end
end
```

**TIP**: proper names for tests are 'spec' or 'example', using the word 'test'
implies that it's after the fact and not before.

The ``describe`` method defines a suite of tests that can share a common setup.
The describe method takes one argument - usually either a class name or a
string and a block.

Use ``it`` blocks for multi-line tests and ``specify`` for one-liners:
```ruby
specify { expect(user.name).to eq("fred") }
```

General form of an RSpec expectation:
```ruby
expect(actual_value).to(matcher)
```


``expect(oject)`` will take an object as an argument and returns a special proxy
object called ``ExpectationTarget``

The ``ExpectationTarget`` responds to three messages:
*  #to  
*  #not_to  
*  #to_not  

All these methods expect as an argument an RSpec matcher

```ruby
expect(project.done?).to be_truthy

# is the same as:

expect(project.done?).to(RSpec::BuiltIn::BeTruthy.new) 
```

The ``ExpectationTarget`` is now holding on to two objects: the project.done?
object and the matcher be_truthy.  When it has both objects it called the
``matches?`` method and checks if it is true or false depending on if you used
``#to`` or ``#not_to``

See page 19 for a diagram of this process

### RSpec Basic Matchers:
```ruby
expect(array).to all(matcher)
expect(actual).to be_truthy
expect(actual).to be_falsy
expect(actual).to be_nil
expect(actual).to be_between(min, max)
expect(actual).to be_within(delta).of(actual)
expect { block }.to change(receiver, message, &block)
expect(actual).to contain_exactly(expected)
expect(actual).to eq(actual)
expect(actual).to have_attributes(key/value pairs)
expect(actual).to match(regex)
expect { block }.to raise_error(exception)
expect(actual).to satisfy { block }
```

The satisfy matcher passes if the block evaluates to true.  
The contain_exactly matcher is true if the expected array and the actual array
contain the same elements, regardless of order.  

Matchers that take block arguments:  are for specifying side effect of blocks
execution, raises an error or that it changes a different value, rather than the
state of a particular object.

Example:
```ruby
expect(["cheese", "burger"]).to contain_exactly(a_string_matching(/ch/), a
string_matching(/urg/))
```

**TIP**: use the rspec command directly to avoid the overhead of starting up
rake.

Each top-level call to ``RSpec.describe`` creates an internal RSpec object
called an example group.

What ``let`` breaks down to:
```ruby
def me
  @me || User.new(name: 'Spencer')
end
```

#### Questions To Ask Before Writing Test:  
*  _Given_: What data does the test need?  
*  _When_: What action is taking place?  
*  _Then_:  What behavior do we need to specify?  


**Perscription 4:** When possible, write your tests to describe your code's
behavior, not its implementation.

**Perscription 5:** Keeping your code as simple as possible allows you to focus
complexity on the areas that really need complexity.

**Perscription 6:** Choose your test data and test-variable names to make it
easy to diagnose features when they happen.  Meaningful names and data that
doesn't overlap are helpful.

When dealing with Time or Dates in your tests make sure to use the Rails Helpers
like: ``6.months.ago`` or ``1.day.ago``.

**TIP**: Use ``rails g resource`` instead of scaffolding in order to get a
new resource that has nothing in it's controllers actions

Versions of Rails before 4.1 need to run ``rake db:test:prepare`` after every
migration in order to keep the test database in sync with the main schema.
Versions 4.1+ will do this automatically.

## Project Creator
```ruby
class CreatesProject
  attr_accessor :name, :task_string, :project

  def initialize(name: "", task_string: "")
    @name = name
    @task_string = task_string
  end

  def build
    self.project = Project.new(name: name)
    project.tasks = convert_string_to_tasks
  end

  def convert_string_to_tasks
    tasks_string.split("\n").map do |task_string|
      title, size = task_string.split(":")
      size = 1 if (size.blank? || size.to_i.zero?)
      Task.new(title: title, size: size)
    end
  end

  def create
    build
    project.save
  end
end
```

### Causes of Slow Tests:

*  Startup time
*  Dependencies within the code that require a lot of objects to be created to
   invoke the method under test
*  Extensive use of the database or other external services during a test

### Avoiding Brittle View Tests

It's often better to test for a DOM ID on the page than particular words since
those words will most likely be changed throughout the development of the
application

```ruby
it "shows the project section" do
  get :dashboard
  expect(response).to have_selector("h2", :text => 'My Projects')
end

# could be turned into:

it "shows the project section" do
  get :dashboard
  expect(response).to have_selector("h2#projects")
end
```

**TIP**: When you are refactoring the 3 things you should be looking for are:
complexity to break up, duplication to combine, and abstractions waiting to be
born.

Great example of refactoring a Name class:

```ruby
class Name
  attr_reader :first_name, :last_name
  def initialize(first, last)
    @first_name, @last_name = first, last
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def sort_name
    "#{last_name} #{first_name}"
  end
end

class User < ActiveRecord::Base
  delegate :full_name, :sort_name, to: :name
  def name
    Name.new(first_name, last_name)
  end
end
```

By doing this extraction, it's easier to test because Name has no dependencies on the database.

```ruby
it "generates sortable names" do
  name = Name.new('spencer', 'dixon')
  expect(name.sort_name).to eq("dixon, spencer")
end
```

### Making Failing Tests Easier To Read:

```ruby
it "finds completed tasks" do
  complete = Task.create(completed_at: 1.day.ago, title: "Completed")
  incomplete = Task.create(completed_at: nil, title: "Incompleted")
  expect(Task.complete.map(:&title).to eq(["Completed"])
end
```

By calling ``.map(:&title)`` we are taking a complex object and making it
simple.  Now the failing test would expect an array with "Completed" in it and
the actual might be something else.



