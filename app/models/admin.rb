class Admin
  attr_reader :username, :password

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def authentication_hash
    hash_string =
      [username, Rails.application.credentials.admin_realm, password].join(":")

    Digest::MD5.hexdigest(hash_string)
  end
end
