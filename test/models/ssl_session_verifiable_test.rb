require 'test_helper'

class SslSessionVerifiableTest < ActiveSupport::TestCase
  def resource_class
    Admin
  end

  def create_resource
    Admin.create
  end

  test 'should respond to remember_me attribute' do
    assert resource_class.new.respond_to?(:verify_session_for_ssl?)
    assert resource_class.new.respond_to?(:ssl_session_verification_options)
  end

  test 'set a default value for ssl_session_verification_options' do
    assert_equal Hash.new, resource_class.ssl_session_verification_options
  end

end
