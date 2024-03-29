class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #deviseのuserモデルに関する記述なので、とりあえずこのコントローラに書いてしまう。
  # ストロングパラメーターを
  # 追加して、サインアップ時にDBに登録されるようにする
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:password])
  end

  #ログイン後に遷移するページ
  def after_sign_in_path_for(current_user)
    current_user
  end

end
