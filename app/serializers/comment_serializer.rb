class CommentSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :user_id, :content, :created_at
end
