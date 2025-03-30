# frozen_string_literal: true

class InvitationGranter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :quantity, :integer
  attribute :user_ids, default: -> { [] }

  validates :users, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def user_ids=(ids)
    @users = nil
    super(ids.compact_blank.map(&:to_i))
  end

  def users
    @users ||= User.where(id: user_ids)
  end

  def grant!
    validate!
    increment_invitations!
  rescue ActiveRecord::RecordInvalid => e
    errors.merge!(e.record.errors)
    raise e
  end

  def status
    { count: users.count, quantity: quantity }
  end

  private

  def increment_invitations!
    User.transaction do
      users.each do |user|
        next if user.admin?

        invitation_limit = (user.invitation_limit || 0) + quantity
        user.update!(invitation_limit:)
      end
    end
  end
end
