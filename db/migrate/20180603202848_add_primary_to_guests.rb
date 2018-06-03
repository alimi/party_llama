class AddPrimaryToGuests < ActiveRecord::Migration[5.2]
  def change
    add_column :guests, :primary, :boolean, default: false
  end
end
