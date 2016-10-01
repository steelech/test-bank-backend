class UploadsController < ApplicationController
	def create
		pdf = CombinePDF.new
		params['file'].each do |key, file|
			pdf << CombinePDF.new(file.tempfile.path)
		end
		folder = File.join(Rails.root, "tmp", "uploads")
		Dir.mkdir(folder) unless File.exists?(folder)
		pdf.save "#{Rails.root}/tmp/uploads/combined.pdf" 
	end
end
