require "test_helper"

class ProfileManagementTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "profile_user",
      email: "profile@example.com",
      password: "Password123!",
      display_name: "Profile User"
    )
  end

  test "signed in user can view profile" do
    sign_in @user, scope: :user

    get profile_path
    assert_response :success
    assert_includes response.body, @user.display_name
  end

  test "user updates display name and bio" do
    sign_in @user, scope: :user

    patch profile_path, params: {
      user: {
        display_name: "Neuer Name",
        bio: "Hier steht eine brandneue Bio."
      }
    }

    assert_redirected_to profile_path
    follow_redirect!

    assert_includes response.body, "Neuer Name"
    assert_includes response.body, "brandneue Bio"

    @user.reload
    assert_equal "Neuer Name", @user.display_name
    assert_equal "Hier steht eine brandneue Bio.", @user.bio
  end
end
