class WebPushJob < ApplicationJob
  queue_as :default

  def perform(event, subscription)
    message_json = {
      title: "Rolezera",
      options: {
        body: event.format_message,
        data: {
          url: event.inviter.whatsapp_link
        }
      }
    }.to_json

    begin
      WebPush.payload_send(
        message: message_json,
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh_key,
        auth: subscription.auth_key,
        vapid: p({
          subject: "mailto:lucas.wolschick@gmail.com",
          public_key: Rails.application.credentials.vapid.public_key,
          private_key: Rails.application.credentials.vapid.private_key
        })
      )
    rescue WebPush::InvalidSubscription, WebPush::ExpiredSubscription
      subscription.destroy
    end
  end
end
