# Using Warden

Warden is a rack middleware that allows you to put hooks in for authentication
with multiple rack applications.  Here is how I set up the config for an app
using invitations:

```ruby
# config/initializers/warden.rb

WhiteBoardV2::Application.middleware.use Warden::Manager

Warden::Manager.after_set_user do |user, auth, opts|
  invitation = auth.request.session[:invitation_token]
  if invitation.present?
    TeamInvitations::Redemption.new(user, invitation).persist!
    auth.request.session[:invitation_token] = ''
  end
end
```

