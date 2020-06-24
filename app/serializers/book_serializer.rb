class BookSerializer < ActiveModel::Serializer
  attributes :id,
    :owner,
    :rent_user,
    :purchaser,
    :publisher_name,
    :status,
    :title,
    :price,
    :author,
    :link,
    :latest_rent_date,
    :return_date,
    :purchase_date,
    :publication_date
end
