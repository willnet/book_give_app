class Message < ApplicationRecord
  belongs_to :book , optional: true

  validates :content, presence: :true, length: {maximum: 800}
  validates :book_id, presence: :true
end
