class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  #マイページを表示する
  def show
    @user = current_user
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