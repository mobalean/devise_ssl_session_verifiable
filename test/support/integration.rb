require 'action_dispatch/testing/integration'

class ActionDispatch::IntegrationTest
  def warden
    request.env['warden']
  end

  def create_admin(options={})
    @admin ||= begin
      admin = Admin.create!(
        :email => options[:email] || 'admin@test.com',
        :password => '123456', :password_confirmation => '123456',
      )
      admin
    end
  end

  def sign_in_as_admin_via_ssl(options={}, &block)
    admin = create_admin(options)
    visit_with_option options[:visit], new_admin_session_url(:protocol => "https")
    fill_in 'email', :with => 'admin@test.com'
    fill_in 'password', :with => '123456'
    yield if block_given?
    click_button 'Sign In'
    admin
  end

  protected

    def visit_with_option(given, default)
      case given
      when String
        visit given
      when FalseClass
        # Do nothing
      else
        visit default
      end
    end

    def prepend_host(url)
      url = "http://#{request.host}#{url}" if url[0] == ?/
      url
    end
end
