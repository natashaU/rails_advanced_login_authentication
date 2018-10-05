ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # helper methods can't be used in tests, so we create a new one like the one
  # in the helper..."logged_in" , but use  a different name so the methods don't 
  # conflict with each other
  def is_logged_in?
    !session[:user_id].nil?
  end
end
