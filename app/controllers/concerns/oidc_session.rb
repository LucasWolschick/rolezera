module OidcSession
  def pending_oidc
    session[:pending_oidc]&.transform_keys(&:to_sym)
  end

  def set_pending_oidc(sub:, email:, email_verified:)
    session[:pending_oidc] = { "sub" => sub, "email" => email, "email_verified" => email_verified }
  end

  def clear_pending_oidc
    session.delete(:pending_oidc)
  end
end
