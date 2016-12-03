class CoursesController < AuthenticatedController
	respond_to :json
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
		form_data = params["data"]["attributes"]
		name = form_data["name"]
		@course = Course.create({name: name})
		render json: @course, status: 203
	end
end
