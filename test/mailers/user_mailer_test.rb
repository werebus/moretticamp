require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "no_reset" do
    mail = UserMailer.accept_invitation
    assert_equal "No reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
