class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :telephone
      t.float :y_coords
      t.float :x_coords
      t.string :postcode
      t.string :status

      t.timestamps
    end
  end
end
