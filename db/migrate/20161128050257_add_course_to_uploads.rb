class AddCourseToUploads < ActiveRecord::Migration
  def change
	  add_reference :uploads, :course, index: true, foreign_key: true
  end
end
