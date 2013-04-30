Warden::Manager.after_authentication do |record, warden, options|
  scope = options[:scope]
  if record.respond_to?(:verify_session_for_ssl?) && record.verify_session_for_ssl? && warden.authenticated?(scope)
    Devise::Controllers::SslSessionVerifiable::Proxy.new(warden).set_ssl_session_verification_cookie(record)
  end
end

Warden::Manager.after_set_user do |record, warden, options|
  scope = options[:scope]
  if warden.request.ssl? && record && record.respond_to?(:verify_session_for_ssl?) && record.verify_session_for_ssl? && warden.authenticated?(scope)
    unless Devise::Controllers::SslSessionVerifiable::Proxy.new(warden).secure_ssl_session?(record)
      Rails.logger.warn("SECURITY: did not find correct #{scope} verification cookie, logging out #{scope}")
      warden.logout(scope)
      throw :warden, :scope => scope
    end
  end
end
