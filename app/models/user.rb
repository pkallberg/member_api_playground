class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String

  attr_accessible :first_name, :last_name, :email

  def full_name
    "#{first_name} #{last_name}"
  end
end