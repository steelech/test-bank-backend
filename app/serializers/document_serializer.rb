class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :name, :course, :s3_key, :s3_bucket
end
