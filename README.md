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


## License

MIT License. Copyright 2013 Mobalean LLC. http://mobalean.com/

