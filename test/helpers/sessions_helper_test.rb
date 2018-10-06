
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael) # Define a user variable using the fixtures.
    remember(@user) # Call the remember method to remember the given user.
  end

  # Verify that current_user is equal to the given user.
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user 
    assert is_logged_in?
  end


# Because the remember method doesn’t set session[:user_id], 
# this procedure will test the desired “remember” branch. 

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end


# convention:
# assert_equal <expected>, <actual>


