class AddResponsesEndAtToParties < ActiveRecord::Migration[5.2]
  def change
    add_column :parties, :responses_end_at, :datetime
  end
end
