## Using Email with Rails

In order to get Mandrill configured properly.. follow this format:

```ruby
# production.rb, test.rb, development.rb or application.rb

YourApp::Application.configure do
  config.action_mailer.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
    :enable_starttls_auto => true, # detects and uses STARTTLS
    :user_name => "MANDRILL_USERNAME",
    :password  => "MANDRILL_PASSWORD", # SMTP password is any valid API key
    :authentication => 'login', # Mandrill supports 'plain' or 'login'
    :domain => 'yourdomain.com', # your domain to identify your server when connecting
  }

  # …
end
```

**Note** By default Heroku set up the configuration variables for Mandrill.
When I was trying to get it to work I didn't realize that my environment
variables were named differently from Mandrills.  MAKE SURE TO DOUBLE CHECK YOUR
CALLS TO ENV IN RAILS APP MATCH THE ENVIRONMENT VARIABLE NAMES ON HEROKU!!!
