class Guest < ApplicationRecord
  belongs_to :party

  default_scope { order(:id) }

  def name
    "#{first_name} #{last_name}".strip
  end

  def last_name
    read_attribute(:last_name).presence || party.family_name
  end
end
