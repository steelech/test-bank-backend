class AddFileTypeToUploads < ActiveRecord::Migration
  def change
	 add_column :uploads, :file_type, :string 
  end
end
