require 'rails_helper'

RSpec.feature "Users", :devise do
  background do
    ActionMailer::Base.deliveries.clear
  end
  before(:each) do
    @user = create(:user)
  end

  feature "サインアップ周り" do

    scenario "サインアップするとメールが送信されて、リンクを踏めば新規登録が完了すること" do
      visit root_path
      click_on "Sign up", match: :first
      fill_in "user_name", with: "ボブ"
      fill_in "email", with: "example2@gmail.com"
      attach_file 'image', "#{Rails.root}/spec/fixtures/test.jpg"
      fill_in "password", with: "foobar"
      fill_in "password_confirmation", with: "foobar"
      expect{click_button "Sign up"}.to change {ActionMailer::Base.deliveries.size}.by(1)

      #メール本文から正規表現を使って認証用のURLを引っこ抜いてる
      mail = ActionMailer::Base.deliveries.last
      body = mail.body.encoded
      url = body[/http[^"]+/]
      visit url
      expect(current_path).to eq "/users/sign_in"
      expect(page).to have_content "アカウントを登録しました"

      #値が間違っていたらログインされないことを確認する
      fill_in "email", with: "different_email@gmail.com"
      fill_in "password", with: "wrong_password"
      click_button "Log in"
      expect(page).to have_content "Email もしくはパスワードが不正です。"

      #値が合っていればしっかりログインされることを確認する
      fill_in "email", with: "example2@gmail.com"
      fill_in "password", with: "foobar"
      click_button "Log in"
      expect(page).to have_content "ボブ"
      expect(page).to have_content "ログインしました"
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

    scenario "サインアップするとメール認証を促すflashが表示されること" do
      sign_up

      expect(page).to have_content "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。"
      expect(current_path).to eq "/"
    end

    scenario "ログイン時にflashが表示されること" do
      log_in @user
      expect(page).to have_content "ログインしました"
    end

    scenario "ログアウト時のflash" do
      log_in @user
      click_on "log_out"
      expect(page).to have_content "ログアウトしました"
    end

  end

  feature "アカウント編集周り" do
    scenario "正常にユーザー情報が更新されること" do
      log_in @user
      user_edit

      expect(@user.reload.name).to eq "変更後の名前"
      expect(@user.reload.email).to eq "different_email@gmail.com"
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
      expect(page).to have_content "0"
      expect(page).to have_content "オファー受付中のあなたの本"
      expect(page).to have_content "アカウント情報の編集"
      expect(page).to have_content "Giveした履歴・Giveされた履歴"
      expect(page).to have_content "届いているGiveオファー"
      expect(page).to have_content "Giveする"
    end

    scenario "マイページに表示されているリンク先が正しいパスになっていること" do
      log_in @user
      click_link "オファー受付中のあなたの本"
      expect(current_path).to eq  "/users/#{@user.id}/registered"
      click_link "マイページ"
      click_link "アカウント情報の編集"
      expect(current_path).to eq "/users/edit"
      click_link "マイページ"
      click_link "Giveした履歴・Giveされた履歴"
      expect(current_path).to eq "/users/#{@user.id}/history"
      click_link "マイページ"
      click_link "届いているGiveオファー"
      expect(current_path).to eq "/users/#{@user.id}/offered"
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

