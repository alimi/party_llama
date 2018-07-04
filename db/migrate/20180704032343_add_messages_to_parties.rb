class AddMessagesToParties < ActiveRecord::Migration[5.2]
  def change
    add_column :parties, :messages, :string, array: true, default: "{}"
  end
end
