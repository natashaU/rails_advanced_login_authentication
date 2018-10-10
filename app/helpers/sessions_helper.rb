module SessionsHelper

	#logs in the given user, user id's encrypted, session is a ruby method for creating cookies
	#destroyed when a user logs out
	def log_in(user)
		session[:user_id] = user.id 
	end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id #permanent is cookies for
    # 20 years, signed is a method. Signed is a method that encrypts ID.
    cookies.permanent[:remember_token] = user.remember_token
  end


	
  def logged_in?
  	!current_user.nil?
  end

   # Returns true if the given user is the current user (to check if you are the same user)
  def current_user?(user)
    user == current_user
  end


  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #raise       # The tests still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

 
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

# Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  ### if you user tries to access another page, helper method
  ## to redirect to the correct login page (save page) have to keep
  ## track and store it first before directing

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    #request object, request.get (get request)
  end
end


