class AddColumnsToUploadsTable < ActiveRecord::Migration
  def change
 	 add_column :uploads, :name, :string
	 add_column :uploads, :course, :string
	 add_column :uploads, :s3_key, :string
	 add_column :uploads, :s3_bucket, :string
	 add_reference :uploads, :user, index: true, foreign_key: true	 
	  
  end
end
