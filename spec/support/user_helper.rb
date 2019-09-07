module UserHelper

  def sign_up
    visit root_path
    click_on "Sign up", match: :first
    fill_in "user_name", with: "ボブ"
    fill_in "email", with: "example2@gmail.com"
    fill_in "password", with: "foobar"
    fill_in "password_confirmation", with: "foobar"

    click_button "Sign up"
  end

  def log_in(user)
    visit root_path
    click_on "Log in", match: :first
    #factorybotで作ったuserの情報を入力する
    fill_in "email",with: user.email
    fill_in "password",with: user.password

    click_button "Log in"
  end

  # ログイン済みでマイページになっているところから
  def user_edit
    click_on "アカウント情報の編集"
    fill_in "name", with: "変更後の名前です"
    fill_in "email", with: "different_email@gmail.com"
    fill_in "password", with: "new-password"
    fill_in "password_confirmation", with: "new-password"

    click_button "Update"
  end

  def mistake_password_confirmation
    click_on "アカウント情報の編集"
    fill_in "name", with: "変更後の名前です"
    fill_in "email", with: "different_email@gmail.com"
    fill_in "password", with: "new_password"
    fill_in "password_confirmation", with: "different_password"

    click_button "Update"
  end

end

