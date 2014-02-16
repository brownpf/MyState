class RequestSerializer < ActiveModel::Serializer
  attributes :id, :telephone, :y_coords, :x_coords, :postcode, :status

end
