class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :registerable,
    :rememberable, :timeoutable, :trackable, :validatable

  has_many :events

  before_create :generate_calendar_access_token

  def full_name
    "#{first_name} #{last_name}"
  end

  def feed_url
    "http://moretti.camp/feed/#{calendar_access_token}.ics"
  end

  private

  def generate_calendar_access_token
    begin
      self.calendar_access_token = SecureRandom.hex
    end while self.class.exists?(calendar_access_token: calendar_access_token)
  end
end
