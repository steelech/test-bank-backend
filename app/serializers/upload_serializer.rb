class UploadSerializer < ActiveModel::Serializer
  attributes :id, :name, :course, :s3_key, :s3_bucket, :file_type
end
