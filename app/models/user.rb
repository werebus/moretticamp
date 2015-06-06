class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, and :lockable
  devise :invitable, :database_authenticatable, :omniauthable, :recoverable,
         :registerable, :rememberable, :timeoutable, :trackable, :validatable,
         omniauth_providers: OAUTH_PROVIDERS.map(&:label)

  has_many :events

  before_save :generate_calendar_access_token, unless: 'calendar_access_token.present?'

  def self.find_for_oath(auth)
    where(auth.slice(:provider, :uid)).first
  end

  def feed_url
    "http://moretti.camp/feed/#{calendar_access_token}.ics"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def invitation_limit
    admin? ? 999 : self[:invitation_limit]
  end

  def send_reset_password_instructions
    if encrypted_password.present?
      super
    elsif invitation_token.present?
      send_no_reset_email(:invited)
    elsif provider.present?
      send_no_reset_email(:oauth)
    end
  end

  protected

  def send_no_reset_email(reason)
    UserMailer.no_reset(self, reason).deliver
  end

  private

  def generate_calendar_access_token
    loop do
      self.calendar_access_token = SecureRandom.hex
      break unless self.class.exists?(calendar_access_token: calendar_access_token)
    end
  end

end
