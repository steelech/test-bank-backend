require 'net/http'
class UploadsController < AuthenticatedController
	respond_to :json
	def create

		num_files = params["files"].to_i
		puts "Number of files: #{num_files}"

		if num_files == 0
			name = params["data"]["attributes"]["name"]
			course_name = params["data"]["attributes"]["course"]
			course = Course.where(name: course_name).first
			s3_key = params["data"]["attributes"]["s3-key"]
		        @upload = Upload.create!({name: name, course: course, s3_key: s3_key})

		else
			puts "#{num_files} files!!!"
		end
		count = 0
		while count < num_files.to_i
			file = params["file-#{count}"]
			puts "file: #{file}"
			count = count + 1
		end
			

		# combine the pdfs into one file and store in /tmp
		#puts "params: #{params}"
		#pdf = CombinePDF.new
		#params['files'].each do |file|
		#	pdf << CombinePDF.new(file.tempfile.path)
		#end
		#folder = File.join(Rails.root, "tmp", "uploads")
		#Dir.mkdir(folder) unless File.exists?(folder)
		#pdf.save "#{Rails.root}/tmp/uploads/combined.pdf"
		#save_pdf(params['files'])

		# now we need to upload the new file to s3
		#s3 = Aws::S3::Client.new(
		#	access_key_id: ENV['AWS_ACCESS_KEY_ID'],
		#	secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
		#)
		#s3Object = Aws::S3::Object.new(
		#'test-bank-assets', 'combined', { client: s3 })

		#s3Object.upload_file("#{Rails.root}/tmp/uploads/combined.pdf")
		# todo: delete tmp/uploads folder after upload, refactor this 
		#signer = Aws::S3::Presigner.new
		#url = signer.presigned_url(:get_object, bucket: "test-bank-assets", key: 'combined', expires_in: 30)
		#puts url

		#cogClient = Aws::CognitoIdentity::Client.new(
		#	region: "us-west-2",
		#	access_key_id: ENV["AWS_ACCESS_KEY_ID"],
		#	secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]

		#)	
		#puts "CLIENT IS GOOD"
		#resp = cogClient.get_open_id_token_for_developer_identity({
		#	identity_pool_id: 'us-west-2:10100c61-ea97-4255-ae90-be2c1a63ade0',
		#	logins: {
		#		"login.testbank" => "steelech@umich.edu"
		#	},
		#})
	
		#user = User.find_by(email: email)
		#puts "user: #{user.email}"
		#user.uploads.create({name: name, course: course, s3_key: filename, s3_bucket: 'test-bank-assets'})

		#data = {
			#name: name,
			#course: course,
			#s3_key: filename,
			#s3_bucket: 'test-bank-assets'

		#}
		render json: {}, status: 202



	end

	def index
		render json: uploads_query(params), status: 202
	end

	private

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
end
