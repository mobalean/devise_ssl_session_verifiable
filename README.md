## Devise SSL Session Verifiable

This is a plugin for [Devise](https://github.com/plataformatec/devise) which allows you to prevent session hijacking when sharing a session between http and https. It verifies the session via an extra cookie which is set upon the initial authentication. This cookie is restricted to SSL connections, so it won't be transferred in a non-secure way. If the user from the session can't be validated this way, she'll need to reauthenticate herself.

### Usage

Add to your Gemfile:

```ruby
gem 'devise_ssl_session_verifiable'
```

Add to your model which already uses devise :ssl_session_verifiable:

```ruby
devise ..., :ssl_session_verifiable
```

Make sure you have all login and other critical operations secured with SSL. You can inforce this in the routes for instance.


### Advanced

In case you would like to provide a special page for users which transition from non-SSL to SSL but fail the verification (maybe because they were logged in insecurely over HTTP), you can use the provided failure app to trigger a custom action. Setup steps:

Setup the custom failure app and route in your routes:

```ruby
  devise_for :users,
    :failure_app => DeviseSslSessionVerifiable::FailureApp,
    :controllers => { :sessions => 'users/sessions' }

  devise_scope :user do
    scope as: "user" do
      resource :session_verification, :only => [:new, :create]
    end
  end
```

The new_user_session_verification_path should be under SSL. In your custom sessions controller, add a verify action like this:

```ruby
class Users::SessionVerificationController < Devise::SessionsController
  def new
    @back_to = stored_location_for(:user)
    if session[:unverified_user]
      @unverified_user = User.serialize_from_session(*session[:unverified_user])
    end
  end
end
```

That way you also have access to the user record for which the ssl verification failed.


## License

MIT License. Copyright 2013 Mobalean LLC. http://mobalean.com/

