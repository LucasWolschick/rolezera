module EventsHelper
  def format_topic(user:, event_topic:)
    event_topic.prompt % { user_name: user.name }
  end
end
