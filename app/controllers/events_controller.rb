class EventsController < ApplicationController
  before_action :validate_no_active_events, except: [ :index ]

  def index
    if @event = Event.get_for(Current.user)
      render "active" and return
    end

    @topics = EventTopic.all()
    @event = Event.new(inviter: Current.user)
  end

  def confirm
    @topic = EventTopic.find_by(key: event_topic_params[:event_topic])
    @event = Event.new(inviter: Current.user, event_topic_id: @topic.id)
    render layout: false
  end

  def new
    @topic = EventTopic.find_by(key: event_topic_params[:event_topic])
    @event = Event.create_for(inviter: Current.user, topic: @topic)
    redirect_to events_path
  end

  private
  def event_topic_params
    params.expect(event: [ :event_topic ])
  end

  def validate_no_active_events
    if Event.get_for(Current.user)
      redirect_to events_path and return
    end
  end
end
