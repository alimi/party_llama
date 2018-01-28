class AddResponsesSubmittedAtToParties < ActiveRecord::Migration[5.2]
  def change
    add_column :parties, :responses_submitted_at, :datetime
  end
end
