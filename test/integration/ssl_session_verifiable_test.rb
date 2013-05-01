require 'test_helper'

class SslSessionVerifiableIntegrationTest < ActionController::IntegrationTest
  def drop_verification_cookie
    cookies.delete('admin_verify')
  end

  def assert_authenticated_and_verified(scope, user)
    assert warden.authenticated?(scope), "expecting #{scope} to be authenticated"
    assert_equal user, warden.user(scope), "expecting correct #{scope} to be signed in"
    assert cookies["#{scope}_verify"], "expecting verify cookie"
  end

  test 'generate verify cookie after authentication' do
    admin = sign_in_as_admin_via_ssl
    assert_response :success
    assert_authenticated_and_verified(:admin, admin)
  end

  test 'generate verify cookie after manual sign in' do
    admin = create_admin
    visit manual_sign_in_admin_url(admin, :protocol => "https")
    assert_response :success
    assert_authenticated_and_verified(:admin, admin)
  end

  test 'generate verify cookie after token sign in' do
    admin = create_admin
    admin.reset_authentication_token!
    assert admin.authentication_token
    visit admin_root_url(admin, :auth_token => admin.authentication_token, :protocol => "https")
    assert_response :success
    assert_authenticated_and_verified(:admin, admin)
  end

  test 'generate remember token after sign in setting cookie options' do
    # We test this by asserting the cookie is not sent after the redirect
    # since we changed the domain. This is the only difference with the
    # previous test.
    swap Devise, :ssl_session_verification_options => { :domain => "omg.somewhere.com" } do
      sign_in_as_admin_via_ssl
      assert_nil request.cookies["admin_verify"]
    end
  end

  test 'access SSL page' do
    sign_in_as_admin_via_ssl
    visit private_url(:protocol => "https")
    assert_response :success
    assert_template 'home/private'
    assert_contain 'Private!'
  end

  test 'access SSL page but no verify cookie' do
    sign_in_as_admin_via_ssl
    drop_verification_cookie
    visit private_url(:protocol => "https")
    assert_not warden.authenticated?(:admin)
    assert_contain 'You need to sign in or sign up before continuing.'
    assert_not_contain 'Private!'
    assert_blank cookies["admin_verify"]
  end

  test 'access non-SSL page but no verify cookie' do
    sign_in_as_admin_via_ssl
    drop_verification_cookie
    visit private_url(:protocol => "http")
    assert_response :success
    assert_template 'home/private'
    assert_contain 'Private!'
  end

  test 'signout removes verify cookie' do
    sign_in_as_admin_via_ssl
    get destroy_admin_session_path
    assert_blank cookies["admin_verify"]
  end
end
