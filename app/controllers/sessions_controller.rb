class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    # 送られてきたメールアドレスでユーザを検索
    user = User.find_by(email: session_params[:email])

    # 引数で受け取ったパスワードをハッシュ化してその結果がDBにあればTrue
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id #セッションにidを格納
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
