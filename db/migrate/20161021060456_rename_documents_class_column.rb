class RenameDocumentsClassColumn < ActiveRecord::Migration
  def change
	  rename_column :documents, :class, :course

  end
end
