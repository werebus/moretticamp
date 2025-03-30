# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :omniauthable, :recoverable,
         :registerable, :rememberable, :timeoutable, :trackable, :validatable,
         validate_on_invite: true,
         omniauth_providers: OauthProvider.labels
  has_secure_token :calendar_access_token

  has_many :events, dependent: :nullify
  has_many :invitations, class_name: 'User', as: :invited_by, dependent: :nullify

  before_save :regenerate_calendar_access_token, if: -> { calendar_access_token.blank? }

  validates :first_name, presence: true, if: -> { last_name.blank? }
  validates :calendar_access_token, uniqueness: { case_sensitive: true }

  class << self
    def active
      invitation_accepted.joins(:events).where(events: { start_date: (5.years.ago..) }).distinct
    end

    def find_for_oauth(auth)
      find_by(provider: auth.provider, uid: auth.uid)
    end

    def to_notify(override: false)
      override ? all : where(email_updates: true)
    end
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def invitation_limit
    admin? ? Float::INFINITY : self[:invitation_limit]
  end

  def invitations?
    invitation_limit.present? && invitation_limit.positive?
  end

  def provider_name
    OauthProvider[provider]&.name
  end

  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end

  def send_reset_password_instructions
    if invited_to_sign_up? || provider.present?
      UserMailer.no_reset(self).deliver_later
    else
      super
    end
  end
end
