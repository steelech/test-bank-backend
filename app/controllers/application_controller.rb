class ApplicationController < ActionController::API
	include ActionController::HttpAuthentication::Token::ControllerMethods
	protected	
	def authenticate_user_from_token!
		puts "authenticating user with token"
		authenticate_with_http_token do |token, options|
			puts "token: {token}"
			user_email = options[:email].presence
			user = user_email && User.find_by_email(user_email)

			if user && Devise.secure_compare(user.authentication_token, token)
				sign_in user, store: false
			end
		end
		puts "end of function"

	end	
end
