class UsersController < ApplicationController
   before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
   #before filters use the before_action command to arrange 
   # for a particular method to be called before the given actions.
    # To require users to be logged in, we define a logged_in_user 
    # method and invoke it using before_action :logged_in_user, security
    # to prevent non logged in users accessing edit page, you want
    # to be logged in to see index of users
    before_action :correct_user,   only: [:edit, :update]
    # correct_user so you can't go to user id 4 (if you are id 1)
    # and edit his profile based on inputing info into a URL, cause you
    # are technically "logged in", making sure the right user has the right
    # permissions

    before_action :admin_user,     only: :destroy
    # only admins can destroy, you have that so that hackers can't issue
    # a delete request from the command line, need to secure the website.

    def index
      # @users = User.all
      @users = User.paginate(page: params[:page])
      # Using the paginate method, we can paginate the users in the sample 
      # application by using paginate in place of all in the index 
      # action  Here the page parameter comes from params[:page], which is 
      # generated automatically by will_paginate ('magic' from gem in views).
    end

    def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      # redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
      #current_user? is a method defined in helpers we created
    end
  

  def new
  	@user = User.new
  end

  
  def show
  	@user = User.find(params[:id])
  end

  
  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user #login the user when a new user is created
      flash[:success] = "Welcome to the Sample App!" #flash method
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

   def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end



  

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
