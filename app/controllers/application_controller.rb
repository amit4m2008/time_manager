class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def authenticate_admin
		if !current_user.blank? && current_user.admin
			#redirect_to admins_path
      true
		else
      sign_out_and_redirect( new_user_session_path )
      flash[:error] = "access denied"
    end
  end
  
  def authenticate_user_aprooval
    if !current_user.blank? && current_user.approved_by_admin
			true
		else
      sign_out_and_redirect( new_user_session_path )
      flash[:error] = "access denied"
    end
  end
end
