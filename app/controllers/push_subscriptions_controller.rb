class PushSubscriptionsController < ApplicationController
  skip_forgery_protection

  def create
    if subscription = Current.user.push_subscriptions.find_by(push_subscription_params)
      subscription.touch
    else
      Current.user.push_subscriptions.create!(push_subscription_params.merge(user_agent: request.user_agent))
    end

    head :ok
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh_key, :auth_key)
  end
end
