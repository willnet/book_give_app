require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  before(:each) do
    @user = create(:user)
  end

  scenario "パスワードを正常にリセットできること" do
    visit root_path
    click_link "Log in"
    click_link "パスワードをお忘れの方はこちら"
    expect(page).to have_content "Password reset"
    expect(current_path).to eq "/users/password/new"
    fill_in "email", with: "example1@gmail.com"
    click_button "Submit"
    expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

    #メール本文から正規表現を使って認証用のURLを引っこ抜いてる
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    expect(page).to have_content "Password edit"

    fill_in "new_password", with: "edit_password"
    fill_in "new_password_confirmation", with: "edit_password"
    click_button "Submit"
    expect(page).to have_content "パスワードが正しく変更されました。"
    expect(current_path).to eq "/users/#{@user.id}"

    # 更新したパスワードでログインできることも確認する
    click_link "ログアウト"
    click_link "Log in"
    fill_in "email", with: "example1@gmail.com"
    fill_in "password", with: "edit_password"
    click_button "Log in"
    expect(page).to have_content "マイケル"
    expect(page).to have_content "ログインしました"
    expect(current_path).to eq "/users/#{@user.id}"
  end

end

