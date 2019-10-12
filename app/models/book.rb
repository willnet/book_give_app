class Book < ApplicationRecord
  belongs_to :giver, class_name: "User", optional: true
  belongs_to :taker, class_name: "User", optional: true
  has_one :message

  validates :name, presence: true
  validates :giver_id, presence: true
  validates :isbn, presence: true


  # searchページで検索したものを入れるための記述
  def self.search(search)
    if search
      # 検索したものがあるならそれと一致したものを戻り値にする
      where(['name LIKE ?', "%#{search}%"])
    else
      # ヒットするものがないなら全てを戻り値にする
      Book.all
    end
  end

end
