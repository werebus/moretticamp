class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :registerable,
    :rememberable, :timeoutable, :trackable, :validatable

  has_many :events

  def full_name
    "#{first_name} #{last_name}"
  end
end
