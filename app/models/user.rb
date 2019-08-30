class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # deviseで使うモジュールたち。
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 自分で追加したカラムにバリデーションをかけておく
  validates :name, presence: true, length: {maximum: 50}
end
