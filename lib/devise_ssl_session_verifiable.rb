require 'devise'

module DeviseSslSessionVerifiable
end

Devise.add_module :ssl_session_verifiable, :model => 'devise/models/ssl_session_verifiable'

module Devise
  module Controllers
    autoload :SslSessionVerifiable, 'devise/controllers/ssl_session_verifiable'
  end

  # Custom domain or key for ssl session verification cookies. Not set by default
  mattr_accessor :ssl_session_verification_options
  @@ssl_session_verification_options = {}
end
