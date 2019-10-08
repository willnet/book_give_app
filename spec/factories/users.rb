FactoryBot.define do
  factory :user do
    #とりあえずサインアップ周りに必要なカラムしか埋めてないから後で必要に応じてやってくれ!!
    name{"マイケル"}
    email{"example1@gmail.com"}
    password{"foobar"}

    # image{ Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg'))}


    before(:create){ |user|
      user.skip_confirmation_notification!
      user.skip_confirmation!
    }

  end
end
