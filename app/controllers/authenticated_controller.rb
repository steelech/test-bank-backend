class AuthenticatedController < ApplicationController
	include ActionController::HttpAuthentication::Token::ControllerMethods
	before_filter :authenticate_user_from_token!

	before_filter :authenticate_user!

	
end
