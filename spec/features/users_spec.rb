require 'rails_helper'

RSpec.feature "Users", type: :feature do

  scenario "サインアップページから新規登録がしっかり出来ること" do
    #sign_up_support.rbでモジュールを作っている
    sign_up

    expect(page).to have_content "ボブ"
    expect(page).to have_http_status(:success)
  end

  scenario "無効な値でサインアップするとSign_up画面ににリダイレクトされること" do
    visit root_path
    click_on "Sign up"
    fill_in "user_name", with: "ボブ"
    fill_in "email", with: "example2@gmail.com"
    fill_in "password", with: "foo"
    fill_in "password_confirmation", with: "foo"

    click_button "Sign up"

    expect(page).to have_content "既にアカウントをお持ちですか？"
  end


  feature "ログイン周り" do
    before(:each) do
      @user = create(:user)
    end

    scenario "ログイン画面からログインが正常にできること" do
      log_in @user
      expect(page).to have_content  "マイケル"
    end

    scenario "無効な値だとログインされずに、ログイン画面に戻ること" do
      visit root_path
      click_on "Log in"
      #factorybotで作ったuserの情報を入力する
      fill_in "email",with: @user.email
      fill_in "password",with: "wrong_password"

      click_button "Log in"
      expect(page).to have_content "Email もしくはパスワードが不正です"
      expect(current_path).to eq new_user_session_path
    end
  end

end
