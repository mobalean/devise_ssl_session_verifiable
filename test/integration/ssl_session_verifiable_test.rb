require 'test_helper'

class SslSessionVerifiableIntegrationTest < ActionController::IntegrationTest
  def drop_verification_cookie
    cookies.delete('admin_verify')
  end

  test 'generate verify cookie after sign in' do
    admin = sign_in_as_admin_via_ssl
    assert_response :success
    assert request.cookies["admin_verify"]
    assert warden.authenticated?(:admin)
    assert warden.user(:admin) == admin
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
  end

  test 'access non-SSL page but no verify cookie' do
    sign_in_as_admin_via_ssl
    drop_verification_cookie
    visit private_url(:protocol => "http")
    assert_response :success
    assert_template 'home/private'
    assert_contain 'Private!'
  end

end
