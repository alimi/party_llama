class Guest < ApplicationRecord
  belongs_to :party

  def name
    "#{first_name} #{last_name}".strip
  end
end
