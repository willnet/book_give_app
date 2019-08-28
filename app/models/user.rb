class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # deviseで使うモジュールたち。
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


end
