FactoryBot.define do
  factory :book do
    name { "マインドセット「やればできる! 」の研究" }
    giver_id { 1 }
    taker_id { 2 }
    isbn { 4794221789 }
  end
end
