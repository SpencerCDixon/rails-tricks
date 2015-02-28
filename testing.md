Table Of Contents:

*  [Testing Markdown](#markdown)



# Markdown
*  Create the object that will be rendering markdown and give it some potential tags  
*  Assert that the proper html tags have been rendered on the page  
```ruby
scenario "view an individual assignment rendered in markdown" do
  assignment = FactoryGirl.create(
    :assignment, body: "## Foo\n\nbar\n\n* item 1\n* item 2")

  visit assignment_path(assignment)

  expect(page).to have_content(assignment.title)
  expect(page).to have_selector("h2", "Foo")
  expect(page).to have_selector("p", "bar")
  expect(page).to have_selector("li", "item 1")
  expect(page).to have_selector("li", "item 2")
end
```
