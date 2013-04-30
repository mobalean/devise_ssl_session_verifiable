class Admin < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :ssl_session_verifiable

end
