## Using Omni Auth With Devise

**Step 1**: 

Add gems to gemfile:

```ruby
gem 'therubyracer'
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
```

**Step 2**: Make sure you have a root to your application

**Step 3**: 

```ruby
rails g devise:install
rails g devise User
rake db:migrate
```

**Step 4 (optional)**: add authentication to every page on website by creating a
before_action in application controller:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end
```

**Step 5**: Update user model to support omniauth

```ruby
rails g migration add_column_to_users provider uid
rake db:migrate
```

**Step 6**: Get client ID and client Secret from OAuth service provider
and set callback as: http://localhost:3000/users/auth/github/callback

**Step 7**: Update devise initializer and set up dotenv rails

```ruby
gem 'dotenv-rails'

bundle install

# go to .gitignore and add:
.env

# create a .env file with your keys
```

Then update devise initializer with new info

```ruby
Devise.setup do |config|
  config.omniauth :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"]
end
```

**Step 8**: Update user model:
```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
     :omniauthable, :omniauth_providers => [:digitalocean]

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
  end
end
```

**Step 9**: Add controller to handle callbacks:

```ruby
Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :products
  root 'products#index'
end
```

Create the controller:
```ruby
class CallbacksController < Devise::OmniauthCallbacksController
    def digitalocean
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end
end
```

**Step 10**: Restart server and should be good to go!
