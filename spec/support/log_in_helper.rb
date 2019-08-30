module LogInSupport

  def log_in(user)
    visit root_path
    click_on "Log in"
    #factorybotで作ったuserの情報を入力する
    fill_in "email",with: user.email
    fill_in "password",with: user.password

    click_button "Log in"
  end
end

