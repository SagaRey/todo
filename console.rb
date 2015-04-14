require 'rubygems'
require 'yaml'
require 'active_record'
require 'bcrypt'
require 'irb'
require 'irb/completion'

config = YAML.load(File.open("config/database.yml"))
ActiveRecord::Base.establish_connection(config)
class Todolist < ActiveRecord::Base
  belongs_to :user
end
class User < ActiveRecord::Base
  has_many :todolists, dependent: :destroy
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
IRB.start