class Admin < ActiveRecord::Base

  devise :database_authenticatable, :rememberable, :ssl_session_verifiable

end
