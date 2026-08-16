# frozen_string_literal: true

class Notification
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :subject, :string
  attribute :body, :string
  attribute :override, :boolean, default: false
  alias override? override

  validates :subject, :body, presence: true
end
