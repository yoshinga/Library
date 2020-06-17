class WishListSerializer < ActiveModel::Serializer
  attributes :id,
    :user_id,
    :title,
    :price,
    :author,
    :link,
    :publication_date
end
