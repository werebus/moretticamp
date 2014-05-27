class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, and :lockable
  devise :invitable, :database_authenticatable, :omniauthable, :recoverable,
    :registerable, :rememberable, :timeoutable, :trackable, :validatable,
    :omniauth_providers => [:google_oauth2, :facebook]

  has_many :events

  before_create :generate_calendar_access_token

  def full_name
    "#{first_name} #{last_name}"
  end

  def feed_url
    "http://moretti.camp/feed/#{calendar_access_token}.ics"
  end

  def self.find_for_oath(auth)
    where(auth.slice(:provider, :uid)).first
  end
  private

  def generate_calendar_access_token
    begin
      self.calendar_access_token = SecureRandom.hex
    end while self.class.exists?(calendar_access_token: calendar_access_token)
  end
end
