class EventsController < ApplicationController
  before_action :validate_no_active_event, except: [ :index ]
  before_action :set_event_draft, except: [ :index ]

  def index
    if @event = Event.get_for(Current.user)
      render "active" and return
    end

    @topics = EventTopic.all()
    set_event_draft
  end

  def set_topic
    topic = EventTopic.find_by(key: event_topic_params)
    @draft.update!(event_topic: topic)
    redirect_to events_invite_path
  end

  def invite
    @invitable = Current.user.friends.where.not(id: @draft.invited.select(:user_id))
    @invitable = @invitable.where('"users"."name" LIKE ?', "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%") if params[:q].present?
  end

  def set_invites
    p = event_invite_params

    @draft.update!(invited_all: p[:invite_all] == "1")
    if @draft.invited_all
      @draft.event_draft_invites.destroy_all
    else
      continue_invited = Array(p[:invited_ids])
      new_invited = Array(p[:invitee_ids])

      # remove any users which aren't still invited
      currently_invited = @draft.invited.pluck(:id).map(&:to_s)
      to_uninvite = (currently_invited - continue_invited)
      @draft.event_draft_invites.where(user_id: to_uninvite).destroy_all

      # add newly invited users
      new_invited.each do |user_id|
        if Current.user.friends.find_by(id: user_id)
          @draft.event_draft_invites.find_or_create_by!(user_id: user_id)
        end
      end
    end

    redirect_to events_invite_path
  end

  def confirm
    render layout: false
  end

  def new
    @draft.publish
    redirect_to events_path
  end

  private
  def event_topic_params
    params.expect(:event_topic)
  end

  def event_invite_params
    params.permit(:invite_all, invitee_ids: [])
    params.fetch(:invite_all)
    params
  end

  def validate_no_active_event
    if Current.user.active_event != nil
      redirect_to events_path and return
    end
  end

  def set_event_draft
    @draft = EventDraft.find_or_create_by!(inviter: Current.user)
  end
end
