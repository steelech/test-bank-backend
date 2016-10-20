class UsersController < ApplicationController
	def show
		render json: current_user 
	end
	def create
		puts "USER!!"
		render json: User.first
	end
end
