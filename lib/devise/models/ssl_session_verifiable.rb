require 'devise/hooks/ssl_session_verifiable'

module Devise
  module Models
    module SslSessionVerifiable
      extend ActiveSupport::Concern

      def verify_session_for_ssl?
        true
      end

      def ssl_session_verification_options
        self.class.ssl_session_verification_options
      end

      module ClassMethods
        Devise::Models.config(self, :ssl_session_verification_options)
      end
    end
  end 
end
