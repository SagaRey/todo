class User < ActiveRecord::Base
  validates :name, presence: true,
                   length: { maximum: 32 },
                   uniqueness: { case_sensitive: false }

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end