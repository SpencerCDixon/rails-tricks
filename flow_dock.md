## Integrating Flowdock Into Rails

Add flowdock gem and dotenv-rails to Gemfile:
```
gem "flowdock"

group :development, :test do
  gem "dotenv-rails"
end
```

Then add the specific flow token in .env file:

```ruby
# .env file
FLOWDOCK_TEST_TOKEN=<token here>
```

This implementation is for sending flows to the chat.  After making this we can
create specific notification types depending on what we want to send.  In this
case we wanted to send Announcement objects so we made an announcement
notification.

```ruby
module Notifications
  class FlowDock
    FROM_SOURCE = 'Spencer-Dixon'
    EMAIL = 'hello@launchacademy.com'

    def initialize(*args)
      @message_args = args.first
      @flow = Flowdock::Flow.new(
        api_token: token,
        source: FROM_SOURCE,
        from: {
          name: FROM_SOURCE,
          address: EMAIL
        }
      )
    end

    def push_to_chat
      @flow.push_to_chat(
        content:  @message_args[:content],
        external_user_name: @message_args[:external_user_name]
      )
    end

    protected
    def token
      if Rails.env.development? || Rails.env.test?
        ENV['FLOWDOCK_TEST_TOKEN']
      else
        ENV['FLOWDOCK_TOKEN']
      end
    end
  end
end
```

Announcement Wrapper:
```ruby
module Notifications
  class AnnouncementNotification

    def initialize(announcement)
      @announcement = announcement
    end

    def dispatch
      Notifications::FlowDock.new(
        content: content,
        external_user_name: external_user_name
      ).push_to_chat
    end

    private

    def content
      "@everyone, #{@announcement.title}: #{@announcement.description}"
    end

    def external_user_name
      "Launch-Staff"
    end
  end
end
```

Finally in our controller that creates announcements we can ``#dispatch`` the
announcement on save:

```ruby
# announcements_controller.rb
  def create
    @team = Team.find(params[:team_id])
    @announcement = @team.announcements.build(announcement_params)

    if @announcement.save
      Notifications::AnnouncementNotification.new(@announcement).dispatch
      flash[:info] = "Added announcement."
      redirect_to team_announcements_path(@team)
    else
      flash[:alert] = "Failed to add announcement."
      render :index
    end
  end
```

There you have it! One way to integrate Flowdock into Rails.

