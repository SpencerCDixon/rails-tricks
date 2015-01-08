## Setting up password reset with Rails

### Step 1 - Write your tests

Before being able to write tests for Mailers we need to add the email_spec gem
to our Gemfile and bundle.

```ruby
# Gemfile
group :test do
  gem email_spec
end
```
Then ``bundle``  

```ruby
require 'rails_helper'

feature 'user resets their password', %Q{
  As an icode user
  I want to request an email to reset my password
  So that I can regain access to my account
} do
  # Acceptance Criteria
  # I must specify a valid email address
  # If an address is found, that address is emailed with a url to reset a
password
  # I must confirm my new password. If the confirmation doesn't
  # match the specified password, I get an error message.
  # Upon resetting the password, I am authenticated
  # The code specified should expire within 24 hours
  # If I redeem the url and change the password, the code should expire

  scenario 'successfully sent email upon request', focus: true do
    ActionMailer::Base.deliveries = []

    user = FactoryGirl.create(:classic_user)
    visit new_password_reset_path

    fill_in 'Email', with: user.email
    click_on 'Reset Password'

    expect(page).to have_content('Email sent with password reset instructions.')
    expect(ActionMailer::Base.deliveries.size).to eq(1)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email).to have_subject('Password reset - Launch Academy')
    expect(last_email).to deliver_to(user.email)
  end
end
```
