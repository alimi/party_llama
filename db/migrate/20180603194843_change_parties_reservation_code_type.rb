class ChangePartiesReservationCodeType < ActiveRecord::Migration[5.2]
  def up
    change_column :parties, :reservation_code, "integer USING CAST(reservation_code AS integer)"
  end

  def down
    change_column :parties, :reservation_code, :string 
  end
end
