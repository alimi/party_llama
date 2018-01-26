class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.references :party, foreign_key: true
      t.boolean :attending_patterson_park, default: false
      t.boolean :attending_douglass_myers, default: false

      t.timestamps
    end
  end
end
