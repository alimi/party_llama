class RenamePartiesNameToFamilyName < ActiveRecord::Migration[5.2]
  def change
    change_table :parties do |t|
      t.rename(:name, :family_name)
    end
  end
end
