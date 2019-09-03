class Book < ApplicationRecord
  belongs_to :giver, class_name: "User", optional: true
  belongs_to :taker, class_name: "User", optional: true


  validates :name, presence: true
  validates :giver_id, presence: true
  validates :isbn, presence: true


end
