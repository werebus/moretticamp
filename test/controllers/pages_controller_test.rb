require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get documents" do
    get :documents
    assert_response :success
  end

end
