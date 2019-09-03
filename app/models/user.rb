class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # deviseで使うモジュールたち。
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :image, ImageUploader

  #過去にuserが貰ったものを取得する
  has_many :took_books, foreign_key: "taker_id", class_name: "Book"
  #今現在、出品中のもの（貰い手が見つかっていない）を取得する
  has_many :now_give_books, -> {where("taker_id is NULL")},foreign_key: "giver_id", class_name: "Book"
  #既に取引が終わったもの（taker_idが決定しているもの）を取得したい（マイページの履歴で使えるよね）
  has_many :already_give_books, -> {where("taker_id is not NULL")}, foreign_key: "giver_id", class_name: "Book"


  # 自分で追加したカラムにバリデーションをかけておく
  validates :name, presence: true, length: {maximum: 50}

  # https://easyramble.com/user-account-update-without-password-on-devise.html
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
