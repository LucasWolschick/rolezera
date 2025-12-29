class AuthController < ApplicationController
  include OidcSession

  skip_before_action :verify_authenticity_token, only: [ :create ]
  unauthenticated_access_only except: [ :destroy ]

  require "net/http"
  require "uri"
  require "json"
  require "jwt"

  def create
    token = verify_google_token params[:credential]

    if !token
      redirect_to root_path, status: :unprocessable_entity
      return
    end

    sub = token["sub"]
    email = token["email"]
    email_verified = token["email_verified"]

    user = User.find_by(google_sub: sub)

    if user
      start_new_session_for user
      redirect_to after_authentication_url
    else
      set_pending_oidc sub: sub, email: email, email_verified: email_verified
      redirect_to sign_up_index_path
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, status: :see_other
  end

  private

  def fetch_google_certs
    Rails.cache.fetch("google_jwks", expires_in: 6.hours) do
      jwks_uri = URI("https://www.googleapis.com/oauth2/v3/certs")
      JSON.parse(Net::HTTP.get(jwks_uri))["keys"]
    end
  end

  def verify_google_token(token)
    jwks_keys = fetch_google_certs
    payload, _ = JWT.decode(token, nil, true, algorithms: [ "RS256" ], jwks: jwks_keys)

    return nil if payload["aud"] != Rails.application.credentials.gcp.oauth_client_id
    return nil if payload["iss"] != "https://accounts.google.com" && payload["iss"] != "accounts.google.com"
    return nil if Time.at(payload["exp"]) < Time.now

    payload
  rescue JWT::DecodeError
    nil
  end
end
