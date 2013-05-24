module DeviseSslSessionVerifiable
  class FailureApp < Devise::FailureApp
    def self.call(env)
      if env["warden.options"][:action] == :unverified_ssl_access
        @unverified_ssl_access_response ||= action(:unverified_ssl_access)
        @unverified_ssl_access_response.call(env)
      else
        super
      end
    end

    def unverified_ssl_access
      store_location!
      if (record = warden_options[:unverified_record])
        klass = record.class
        session["unverified_#{scope}"] = klass.serialize_into_session(record)
      end
      flash[:alert] = i18n_message(:unverified_ssl_access)
      redirect_to verify_session_path
    end

    private
    def verify_session_path
      opts  = {}
      route = :"verify_#{scope}_session_path"
      opts[:format] = request_format unless skip_format?

      config = Rails.application.config
      opts[:script_name] = (config.relative_url_root if config.respond_to?(:relative_url_root))

      context = send(Devise.available_router_name)
      if context.respond_to?(route)
        context.send(route, opts)
      else
        scope_path
      end
    end
  end
end
