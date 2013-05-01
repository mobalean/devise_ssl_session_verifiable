class AdminsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:manual_sign_in]

  def index
  end

  def manual_sign_in
    admin = Admin.find(params[:id])
    sign_in_and_redirect(admin)
  end
end
