# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def no_reset_invited
    @user = FactoryBot.create(:user, :invited)
    UserMailer.no_reset(@user)
  end

  def no_reset_oauth
    @user = FactoryBot.create(:user, :oauth)
    UserMailer.no_reset(@user)
  end
end
