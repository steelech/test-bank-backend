class UsersController < ApplicationController
	# used for current user feature on frontend
	def show
		authenticate_user_from_token!
		authenticate_user!
		render json: current_user 
	end
	def create
		user = User.create(email: params[:identification], password: params[:password])
		render json: user 
	end
end
