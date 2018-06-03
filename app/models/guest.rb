class Guest < ApplicationRecord
  belongs_to :party

  scope :primary, -> { where(primary: true) }

  def name
    "#{first_name} #{last_name}".strip
  end

  def last_name
    read_attribute(:last_name).presence || party.family_name
  end
end
