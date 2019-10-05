require 'rails_helper'

# :devise do にしてみた、これでcurrent_userが使えるのかどうか
RSpec.feature "Users", :devise do
  before(:each) do
    #FactoryBotでuserだけは作成して使い回せるようにしておく
    @user = create(:user)
  end

  feature "サインアップ周り" do

    scenario "サインアップするとメール認証を促すflashが表示されること" do
      sign_up
      expect(page).to_not have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"
      expect(current_path).to eq "/"
    end
    scenario "サインアップページから新規登録がしっかり出来ること" do
      #sign_up_support.rbでモジュールを作っている
      sign_up
      expect(page).to have_content "ボブ"
      expect(page).to have_css ".profile-image"
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

    scenario "ログインしていないならtopページにlog_inとsign_upを促すものが表示されること" do
      visit root_path
      expect(page).to have_content "すでにアカウントをお持ちですか？"
      expect(page).to have_content "まずは新規登録から"
      click_link "Sign up", match: :first
      expect(current_path).to eq  new_user_registration_path
    end

    scenario "ログインしていればtopぺージにlog_inとsign_upのレコメンドが表示されないこと" do
      visit root_path
      log_in @user
      visit root_path
      expect(page).to_not have_content "すでにアカウントをお持ちですか？"
      expect(page).to_not have_content "まずは新規登録から"
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

  feature "アカウント編集周り" do
    scenario "正常にユーザー情報が更新されること" do
      log_in @user
      user_edit
      expect(@user.reload.name).to eq "変更後の名前"
      expect(@user.reload.email).to eq "different_email@gmail.com"
      # expect(@user.reload.password).to eq "new-password"
    end

    scenario "変更された情報でログインできること" do
      log_in @user
      user_edit
      click_on "ログアウト"
      click_on "Log in", match: :first
      fill_in "email", with: "different_email@gmail.com"
      fill_in "password", with: "new-password"
      click_button "Log in"

      expect(page).to have_content "ログインしました"
    end

    scenario "passwordとpassword_confirmationが一致していなければエラーになること" do
      log_in @user
      mistake_password_confirmation
      expect(page).to have_content "Password confirmationとPasswordの入力が一致しません"
    end
  end


  feature "マイページ周り" do
    scenario "マイページのviewが正常に表示されていること" do
      log_in @user
      expect(page).to have_content "オファー受付中のあなたの本"
      expect(page).to have_content "アカウント情報の編集"
      expect(page).to have_content "Giveした履歴・Giveされた履歴"
      expect(page).to have_content "届いているGiveオファー"
      expect(page).to have_content "Giveする"
    end

    scenario "マイページに表示されているリンク先が正しいパスになっていること" do
      log_in @user
      click_link "オファー受付中のあなたの本"
      expect(current_path).to eq  "/users/1/registered"
      click_link "マイページ"
      click_link "アカウント情報の編集"
      expect(current_path).to eq "/users/edit"
      click_link "マイページ"
      click_link "Giveした履歴・Giveされた履歴"
      expect(current_path).to eq "/users/1/history"
      click_link "マイページ"
      click_link "届いているGiveオファー"
      expect(current_path).to eq "/users/1/offered"
      click_link "マイページ"
      click_link "Giveする"
      expect(current_path).to eq "/book/new_give"
    end
  end

  feature "viewが正常に表示されているか周り" do
    scenario "使い方ページ" do
      visit root_path
      click_link "使い方"
      expect(page).to have_content "Giveするなら"
      expect(page).to have_content "Giveされるなら"
    end

    scenario "オファー受付中の本を表示するページ" do
      log_in @user
      click_link "オファー受付中のあなたの本"
      expect(page).to have_content "Registered"
      expect(page).to have_content "#{@user.name}さんは以下の本を登録済みです"
      expect(page).to have_content "詳しい流れや方法は使い方をご確認ください。"
    end

    scenario "アカウント情報の編集ページ" do
      log_in @user
      click_link "アカウント情報の編集"
      expect(page).to have_content "Edit"
      expect(page).to have_content "６文字以下で入力してください"
      expect(page).to have_content "(６文字以上) パスワードの変更が不要な場合は空欄のままUpdateボタンを押してください"
    end

    scenario "Giveした履歴のページ" do
      log_in @user
      click_link "Giveした履歴・Giveされた履歴"
      expect(page).to have_content "History"
      expect(page).to have_content "Giveした履歴"
      expect(page).to have_content "Giveされた履歴"
      expect(page).to have_content "出品する"
    end

    scenario "届いているGiveオファーページ" do
      log_in @user
      click_link "届いているGiveオファー"
      expect(page).to have_content "Offered"
      expect(page).to have_content "#{@user.name}さんに届いたGiveオファーです"
      expect(page).to have_content "詳しい流れや方法は使い方をご確認ください。"
    end

    scenario "新しく本を登録する(new_give)ページ" do
      log_in @user
      click_link "Giveする"
      expect(page).to have_content "Giveする準備は驚くほど簡単です。 ISBNから書籍を検索し、Giveする本を選択してください。"
      expect(page).to have_content "詳しい流れや方法は使い方をご確認ください。"
    end
  end

end

