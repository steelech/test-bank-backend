class CoursesController < AuthenticatedController
	def index
		# renders a list of all the courses
		if params[:name]
			@courses = Course.first
		else
			@courses = Course.all
		end
		render json: @courses, status: 200
	end

	def show
		# renders one course 
	end

	def new
		# not sure if we will even use this
	end

	def create
		# use either this or "new" for creating a new course
	end
end
