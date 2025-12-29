module OidcSession
  def pending_oidc
    session[:pending_oidc]&.transform_keys(&:to_sym)
  end

  def set_pending_oidc(sub:, email:)
    session[:pending_oidc] = { "sub" => sub, "email" => email }
  end

  def clear_pending_oidc
    session.delete(:pending_oidc)
  end
end
