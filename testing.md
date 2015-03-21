Table Of Contents:

*  [Testing Markdown](#markdown)  
*  [Testing Mailers](#mailers)  



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

# Mailers  
- add `email_spec` to Gemfile and budle  
- add these configs to `rails_helper`  

```ruby
config.include(EmailSpec::Helpers)
config.include(EmailSpec::Matchers)
```

Here is an example acceptance test:

```ruby
scenario 'specifies valid information, registers spot' do
  #clear out mail deliveries
  ActionMailer::Base.deliveries = []

  prev_count = ParkingRegistration.count
  visit '/'
  fill_in 'First name', with: 'John'
  fill_in 'Last name', with: 'Smith'
  fill_in 'Email', with: 'user@example.com'
  fill_in 'Spot number', with: 5
  click_button 'Register'

  expect(page).to have_content('You registered successfully')
  expect(ParkingRegistration.count).to eq(prev_count + 1)

  # upon registering, a confirmation email should be delivered,
  # so ActionMailer::Base.deliveries should include the email:
  expect(ActionMailer::Base.deliveries.size).to eql(1)

  # the email we just sent should have the proper subject and recipient:
  last_email = ActionMailer::Base.deliveries.last
  expect(last_email).to have_subject('Parking Confirmation')
  expect(last_email).to deliver_to('user@example.com')
end
```
