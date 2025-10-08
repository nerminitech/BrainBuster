require "test_helper"

class ProfileManagementTest < ActionDispatch::IntegrationTest
  setup do
    # Standard-Nutzer zum Testen der Profilansicht/-bearbeitung anlegen.
    @user = User.create!(
      username: "profile_user",
      email: "profile@example.com",
      password: "Password123!",
      display_name: "Profile User"
    )
  end

  test "signed in user can view profile" do
    # 1) Nutzer anmelden und Profil-Seite laden.
    sign_in @user, scope: :user

    get profile_path
    assert_response :success
    assert_includes response.body, @user.display_name
  end

  test "user updates display name and bio" do
    # 1) Anmelden, um das Formular absenden zu duerfen.
    sign_in @user, scope: :user

    # 2) PATCH-Request simuliert das Ausfuellen des Formulars.
    patch profile_path, params: {
      user: {
        display_name: "Neuer Name",
        bio: "Hier steht eine brandneue Bio."
      }
    }

    # 3) Erwartung: Redirect zur Profilseite und die neuen Daten erscheinen in der Response.
    assert_redirected_to profile_path
    follow_redirect!

    assert_includes response.body, "Neuer Name"
    assert_includes response.body, "brandneue Bio"

    # 4) Persistenz pruefen: Datensatz wurde in der Datenbank aktualisiert.
    @user.reload
    assert_equal "Neuer Name", @user.display_name
    assert_equal "Hier steht eine brandneue Bio.", @user.bio
  end
end
