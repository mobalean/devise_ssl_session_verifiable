module Devise
  module Controllers
    module SslSessionVerifiable
      # Return default cookie values retrieved from session options.
      def self.cookie_values
        Rails.configuration.session_options.slice(:path, :domain).merge(secure: true)
      end

      # A small warden proxy so we can remember and forget uses from hooks.
      class Proxy #:nodoc:
        include Devise::Controllers::SslSessionVerifiable

        delegate :cookies, :env, :to => :@warden

        def initialize(warden)
          @warden = warden
        end
      end

      def secure_ssl_session?(resource)
        scope = Devise::Mapping.find_scope!(resource)
        cookies.signed_or_encrypted[ssl_session_verification_key(scope)] == resource.id
      rescue => err
        cookies.delete(ssl_session_verification_key(scope), base_ssl_session_verification_cookie_values(resource))
        false
      end

      def set_ssl_session_verification_cookie(resource)
        scope = Devise::Mapping.find_scope!(resource)
        cookies.signed_or_encrypted[ssl_session_verification_key(scope)] = ssl_session_verification_cookie_values(resource)
      end

      def remove_ssl_session_verification_cookie(resource)
        scope = Devise::Mapping.find_scope!(resource)
        cookies.delete(ssl_session_verification_key(scope), base_ssl_session_verification_cookie_values(resource))
      end

      protected

      def ssl_session_verification_key(scope)
        "#{scope}_verify"
      end

      def base_ssl_session_verification_cookie_values(resource)
        Devise::Controllers::SslSessionVerifiable.cookie_values.merge!(resource.ssl_session_verification_options)
      end

      def ssl_session_verification_cookie_values(resource)
        options = { :httponly => true }
        options.merge!(base_ssl_session_verification_cookie_values(resource))
        options[:value] = resource.id
        if resource.respond_to?(:remember_me?) && (
             Gem.loaded_specs['devise'].version.to_s <= '3.5.4' ?
               resource.remember_me? :
               resource.remember_me?(resource.rememberable_value, Time.now)
           )
          options[:expires] = Time.now.years_since(10)
        end
        options
      end
    end
  end
end
