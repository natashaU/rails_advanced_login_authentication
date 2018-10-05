module SessionsHelper

	#logs in the given user, user id's encrypted, session is a ruby method for creating cookies
	#destroyed when a user logs out
	def log_in(user)
		session[:user_id] = user.id 
	end


	def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
  	!current_user.nil?
  end

  def log_out
    session.delete(:user_id) ## delete method, session method,
    @current_user = nil
  end

end
