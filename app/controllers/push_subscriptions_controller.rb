class PushSubscriptionsController < ApplicationController
  allow_unauthenticated_access only: [ :status ]
  skip_forgery_protection

  def cta
    render "notifications/cta", layout: false
  end

  def subscribe
    subscription = Current.user.push_subscriptions.find_or_initialize_by(
      endpoint: push_subscription_params[:endpoint]
    )

    subscription.update!(
      push_subscription_params.merge(user_agent: request.user_agent)
    )

    head :ok
  end

  def status
    if !authenticated?
      return head :unauthorized
    end

    exists = Current.user.push_subscriptions.exists?(endpoint: params[:endpoint])
    head(exists ? :no_content : :not_found)
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh_key, :auth_key)
  end
end
