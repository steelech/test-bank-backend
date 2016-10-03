class AddNameColumnToDocuments < ActiveRecord::Migration
  def change
	  add_column :documents, :name, :string
	  add_column :documents, :class, :string
	  add_column :documents, :s3_key, :string
	  add_column :documents, :s3_bucket, :string
	  add_column :documents, :url, :string
  end
end
