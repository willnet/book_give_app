module SignUpSupport

  def sign_up
    visit root_path
    click_on "Sign up"
    fill_in "user_name", with: "ボブ"
    fill_in "email", with: "example2@gmail.com"
    fill_in "password", with: "foobar"
    fill_in "password_confirmation", with: "foobar"

    click_button "Sign up"
  end
end

RSpec.configure do |config|
  config.include SignUpSupport
end