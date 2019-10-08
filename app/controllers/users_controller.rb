class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  #マイページを表示する
  def show
    @user = User.find_by(id: params[:id])
  end

  # 登録済みの本を照会する
  def registered
    @user = User.find_by(id: params[:id])
  end

  #Giveした履歴とGIveされた履歴を表示するページ
  def history
    @user = User.find_by(id: params[:id])
  end

  # 届いているオファーを確認できるページ
  def offered
    @user = User.find_by(id: params[:id])
  end

  private

  #ログインしているだけじゃなくて正しいユーザーかどうかを確認する
  def correct_user
    @user = User.find(params[:id])
    if !(@user == current_user)
      flash[:notice] = "アクセス権限がありません"
      redirect_to(root_url)
    end
  end

end