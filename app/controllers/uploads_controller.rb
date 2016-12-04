require 'net/http'
class UploadsController < AuthenticatedController
	respond_to :json
	def create

		num_files = params["files"].to_i
		puts "Number of files: #{num_files}"

		if num_files == 0
			name = params["data"]["attributes"]["name"]
			course_name = params["data"]["attributes"]["course"]
			file_type = params["data"]["attributes"]["file-type"]
			course = Course.where(name: course_name).first
			s3_key = params["data"]["attributes"]["s3-key"]
		        @upload = Upload.create!({name: name, course: course, s3_key: s3_key, file_type: file_type})
		else
			# TODO: handle multiple files, each with a name and course
			name = params["name"]
			course_name = params["course"]
			file_type = params["file_type"]
			bucket = "test-bank-assets"
			s3_key = name.downcase.gsub(/\s/, "") + course_name.downcase.gsub(/\s/, "")
			save_pdf(files)
			s3 = Aws::S3::Client.new(
				access_key_id: ENV['AWS_ACCESS_KEY_ID'],
				secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
			)
			s3Object = Aws::S3::Object.new(bucket, s3_key, client: s3)
			s3Object.upload_file("#{Rails.root}/tmp/uploads/combined.pdf")
			course = Course.where(name: course_name).first
			@upload = Upload.create({name: name, course: course, s3_key: s3_key, file_type: file_type})
		end
		render json: @upload, status: 202
	end

	def index
		render json: uploads_query(params), status: 202
	end

	private

	def save_file_record(params)
		Upload.create!({name: params.name})
	end

	def combine_files(params) 
	end

	def uploads_query(params)
		if params[:course]
			@course = Course.where(name: params[:course]).first
			@uploads = @course.uploads
		elsif params[:mine]
			if params[:search]
				puts "USER SEARCH"
				@uploads = current_user.uploads.where("name LIKE (?)", "%#{params[:search]}%")
			else
				@uploads = current_user.uploads
			end
		else
			if params[:search]
				puts "ALL SEARCH"
				@uploads = Upload.where("name LIKE (?)", "%#{params[:search]}%")
			else
				@uploads = Upload.all
				puts "@uploads: #{@uploads}"
			end
		end
		@uploads
	end

	def save_pdf(files)
		pdf = CombinePDF.new
		files.each do |file|
			pdf << CombinePDF.new(file.tempfile.path)
		end
		folder = File.join(Rails.root, "tmp", "uploads")
		Dir.mkdir(folder) unless File.exists?(folder)
		pdf.save "#{Rails.root}/tmp/uploads/combined.pdf"
	end
	
	def files()
		puts "params: #{params}"
		num_files = params["files"].to_i
		count = 0
		@files = []
		while count < num_files.to_i
			file = params["file-#{count}"]
			@files.push(file)
			puts "file: #{file}"
			count = count + 1
		end
		@files
	end
end
