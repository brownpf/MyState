class PermittedParams < Struct.new(:params)
  %w(request).each do |m|
    define_method(m) { params.require(m.to_sym).permit(*send("#{m}_attributes".to_sym)) }
  end

  def video_attributes
    [:telephone, :y_coords, :x_coords, :postcode, :status]
  end


end