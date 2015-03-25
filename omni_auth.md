### Using Omni Auth in Rails

1.  Go to whichever provider you want to use and set up an app/the proper
callbacks.  

Callbacks for google look like: 
`https://localhost:3000/auth/google_oauth2/callback`

2.  Write tests for creating the user.  Mock out the auth request that you will
need for creating a user.

For example:
```ruby
  OmniAuth.config.mock_auth[:google_oauth2] = {
    "provider" => "google_oauth2",
    "uid" => "123456",
    "info" => {
      "email" => "spencerdixon@example.com",
      "name" => "Spencer Dixon",
      "first_name" => "Spencer",
      "last_name" => "Dixon",
      "image"=>"https://lh6.googleusercontent.com/-AskbC7sGK7A/AAAAAAAAAAI/AAAAAAAAADA/nTDC13Uvcoc/photo.jpg?sz=50"
    }
  }
```

Here is what the full test looked like:

```ruby
require "rails_helper"

feature "guest creates account" do

  scenario "successful sign up with valid github credentials" do
    OmniAuth.config.mock_auth[:google_oauth2] = {
      "provider" => "google_oauth2",
      "uid" => "123456",
      "info" => {
        "email" => "spencerdixon@example.com",
        "name" => "Spencer Dixon",
        "first_name" => "Spencer",
        "last_name" => "Dixon",
        "image"=>"https://lh6.googleusercontent.com/-AskbC7sGK7A/AAAAAAAAAAI/AAAAAAAAADA/nTDC13Uvcoc/photo.jpg?sz=50"
      }
    }

    visit root_path

    click_link "Sign In With Google"

    expect(page).to have_content("Signed in as Spencer Dixon")
    expect(page).to have_link("Sign Out", session_path)

    expect(User.count).to eq(1)
  end
end
```

3.  Add the proper initializer:

```ruby
# config/initializer/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end
```

4.  Make sure to set up test mode in rails_helper

```ruby
  config.before :each do
    OmniAuth.config.test_mode = true
  end
```

5.  Set up sessions controller:

```ruby
class SessionsController < ApplicationController
  def new
    redirect_to '/auth/google_oauth2'
  end

  def create
    user = User.find_or_create_from_omniauth(auth_hash)
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Signed out successfully."
    redirect_to root_path
  end

  def failure
    redirect_to root_path, notice: "Unable to sign in."
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
```

6.  Fix routes to work properly:

```ruby
 
Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"

  resource :session, only: [:new, :create, :destroy] do
    get "failure", on: :member
  end

  root "welcome#index"
end
```

7.  Add CLIENT_SECRET and CLIENT_ID to your .env file.  Also make a .env.sample
file so others know how to properly set up your app.  Add `gem 'dotenv-rails'`
to your gem file to properly load your environment variables that will be used
in the initializer

8.  Create some session helpers for your views.


```ruby
module SessionHelper
  def user_signed_in?
    !session[:user_id].nil?
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
endmodule SessionHelper
  def user_signed_in?
    !session[:user_id].nil?
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end
```

### Combining Devise with Omni Auth
