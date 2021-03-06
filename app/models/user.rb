# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, and :lockable
  devise :invitable, :database_authenticatable, :omniauthable, :recoverable,
         :registerable, :rememberable, :timeoutable, :trackable, :validatable,
         validate_on_invite: true,
         omniauth_providers: OauthProvider.labels

  has_many :events, dependent: :nullify
  has_many :invitations, class_name: 'User', as: :invited_by, dependent: :nullify

  before_save :generate_calendar_access_token,
              unless: -> { calendar_access_token.present? }

  validates :first_name,
            presence: { message: "can't be blank if Last Name is blank" },
            if: -> { last_name.blank? }

  def self.find_for_oath(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end

  def self.to_notify(override: false)
    override ? all : where(email_updates: true)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def invitation_limit
    admin? ? Float::INFINITY : self[:invitation_limit]
  end

  def invitations?
    invitation_limit.present? && invitation_limit.positive?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def send_reset_password_instructions
    if invited_to_sign_up?
      UserMailer.no_reset(self, 'invited').deliver_later
    elsif provider.present?
      UserMailer.no_reset(self, 'oauth').deliver_later
    else
      super
    end
  end

  private

  def generate_calendar_access_token
    loop do
      self.calendar_access_token = SecureRandom.hex
      break unless User.exists?(calendar_access_token: calendar_access_token)
    end
  end
end
