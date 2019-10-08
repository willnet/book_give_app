FactoryBot.define do
  factory :message do
    image { "MyString" }
    book_id { "" }
    giver_id { 1 }
    taker_id { 1 }
    content { "MyText" }
  end
end
