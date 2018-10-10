class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end


  
  def destroy
    log_out if logged_in? #method defined in helpers, if conditional to not cause
    #bugs if logged out of one browser and not the other (sessions id destroyed automaticlally when you
    #close browser but cookie still there )
    redirect_to root_url
  end
end
