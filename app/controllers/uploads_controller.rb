require 'net/http'
class UploadsController < AuthenticatedController
	respond_to :json
	def create
		# combine the pdfs into one file and store in /tmp
		#puts "params: #{params}"
		#pdf = CombinePDF.new
		#params['files'].each do |file|
		#	pdf << CombinePDF.new(file.tempfile.path)
		#end
		#folder = File.join(Rails.root, "tmp", "uploads")
		#Dir.mkdir(folder) unless File.exists?(folder)
		#pdf.save "#{Rails.root}/tmp/uploads/combined.pdf"
		puts params
		save_pdf(params['files'])

		# now we need to upload the new file to s3
		s3 = Aws::S3::Client.new(
			access_key_id: ENV['AWS_ACCESS_KEY_ID'],
			secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
		)
		s3Object = Aws::S3::Object.new(
		'test-bank-assets', 'combined', { client: s3 })

		s3Object.upload_file("#{Rails.root}/tmp/uploads/combined.pdf")
		# todo: delete tmp/uploads folder after upload, refactor this 
		signer = Aws::S3::Presigner.new
		url = signer.presigned_url(:get_object, bucket: "test-bank-assets", key: 'combined', expires_in: 30)
		puts url

		cogClient = Aws::CognitoIdentity::Client.new(
			region: "us-west-2",
			access_key_id: ENV["AWS_ACCESS_KEY_ID"],
			secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]

		)	
		puts "CLIENT IS GOOD"
		resp = cogClient.get_open_id_token_for_developer_identity({
			identity_pool_id: 'us-west-2:956f2a12-44f6-4adb-906e-c0fc4c103649',
			logins: {
				"login.testbank" => "steelech@umich.edu"
			},
		})
		puts "Response: #{resp.inspect}"
		puts "identity_id: #{resp.identity_id}"
		puts "token: #{resp.token}"
		
		data = {
			identity_id: resp.identity_id,
			token: resp.token
		}
		render json: data, status: 202



	end
	private

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
