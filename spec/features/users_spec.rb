require 'rails_helper'

# :devise do にしてみた、これでcurrent_userが使えるのかどうか
RSpec.feature "Users", :devise do
  before(:each) do
    #FactoryBotでuserだけは作成して使い回せるようにしておく
    @user = create(:user)
  end

  feature "サインアップ周り" do
    scenario "サインアップページから新規登録がしっかり出来ること" do
      #sign_up_support.rbでモジュールを作っている
      sign_up

      expect(page).to have_content "ボブ"
      expect(page).to have_http_status(:success)
    end

    scenario "無効な値でサインアップするとSign_up画面ににリダイレクトされること" do
      visit root_path
      click_on "Sign up",  match: :first
      fill_in "user_name", with: "ボブ"
      fill_in "email", with: "example2@gmail.com"
      fill_in "password", with: "foo"
      fill_in "password_confirmation", with: "foo"

      click_button "Sign up", match: :first

      expect(page).to have_content "既にアカウントをお持ちですか？"
    end

  end


  feature "ログイン周り" do

    scenario "ログインしていないならtopページにlog_inとsign_upのレコメンドが表示されること" do
      visit root_path
      expect(page).to have_content "すでにアカウントをお持ちですか？"
      expect(page).to have_content "まずは新規登録から"
      click_link "Sign up", match: :first
      expect(current_path).to eq  new_user_registration_path
    end


    scenario "ログイン画面からログインが正常にできること" do
      log_in @user
      expect(page).to have_content  @user.name
    end

    scenario "無効な値だとログインされずに、ログイン画面に戻ること" do
      visit root_path
      click_on "Log in", match: :first
      #factorybotで作ったuserの情報を入力する
      fill_in "email",with: @user.email
      fill_in "password",with: "wrong_password"

      click_button "Log in"
      expect(page).to have_content "Email もしくはパスワードが不正です"
      expect(current_path).to eq new_user_session_path
    end
  end

  feature "flash周り" do

    scenario "ログイン時にflashが表示されること" do
      log_in @user
      expect(page).to have_content "ログインしました"
    end

    scenario "ログアウト時のflash" do
      log_in @user
      click_on "log_out"
      expect(page).to have_content "ログアウトしました"
    end

    scenario "サインアップ時のflash" do
      sign_up
      expect(page).to have_content "アカウント登録が完了しました"
    end
  end

  # feature "アカウント編集周り" do
  #   scenario "正常にユーザー情報が更新されること" do
  #     log_in @user
  #     user_edit
  #     expect(@user.reload.name).to eq "変更後の名前です"
  #     expect(@user.reload.email).to eq "different_email@gmail.com"
  #     expect(@user.reload.password).to eq "new_password"
  #   end
  #
  #   scenario "変更された情報でログインできること" do
  #     log_in @user
  #     user_edit
  #     click_on "ログアウト"
  #     click_on "Log in"
  #     fill_in "email", with: "different_email@gmail.com"
  #     fill_in "password", with: "new_password"
  #     click_button "Log in"
  #
  #     expect(page).to have_content "ログインしました"
  #   end
  #
  #   scenario "passwordとpassword_confirmationが一致していなければエラーになること" do
  #     log_in @user
  #     mistake_password_confirmation
  #     expect(page).to have_content "あい"
  #   end
  # end


  feature "マイページ周り" do
    scenario "viewが正常に表示されていること" do
      log_in @user
      expect(page).to have_content "オファー受付中のあなたの本"
      expect(page).to have_content "アカウント情報の編集"
      expect(page).to have_content "Giveした履歴・Giveされた履歴"
      expect(page).to have_content "届いているGiveオファー"
      expect(page).to have_content "欲しい本をオファーする"
      expect(page).to have_content "Giveする"
    end
  end


end

