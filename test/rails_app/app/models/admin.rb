class Admin < ActiveRecord::Base

  devise :database_authenticatable, :token_authenticatable, :rememberable, :ssl_session_verifiable

end
