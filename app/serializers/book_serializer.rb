class BookSerializer < ActiveModel::Serializer
  attributes :id,
    :owner_id,
    :rent_user_id,
    :purchaser_id,
    :publisher_id,
    :status,
    :price,
    :author,
    :link,
    :latest_rent_date,
    :return_date,
    :purchase_date,
    :publication_date
end
