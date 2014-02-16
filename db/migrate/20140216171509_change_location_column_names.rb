class ChangeLocationColumnNames < ActiveRecord::Migration
  def change
    add_column :requests, :latitude, :float
    add_column :requests, :longitude, :float
    remove_column :requests, :x_coords
    remove_column :requests, :y_coords
  end
end
