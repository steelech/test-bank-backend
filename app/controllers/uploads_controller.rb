class Authenticated < ApplicationController
	def create
		# combine the pdfs into one file and store in /tmp
		puts "params: #{params}"
		pdf = CombinePDF.new
		params['files'].each do |file|
			pdf << CombinePDF.new(file.tempfile.path)
		end
		folder = File.join(Rails.root, "tmp", "uploads")
		Dir.mkdir(folder) unless File.exists?(folder)
		pdf.save "#{Rails.root}/tmp/uploads/combined.pdf"

		# now we need to upload the new file to s3
		s3 = Aws::S3::Client.new(
			access_key_id: ENV['AWS_ACCESS_KEY_ID'],
			secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
		)
		
		s3Object = Aws::S3::Object.new(
		'test-bank-assets', 'combined', { client: s3 })

		s3Object.upload_file("#{Rails.root}/tmp/uploads/combined.pdf")
		# todo: delete tmp/uploads folder after upload, refactor this 
	end
end
