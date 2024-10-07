class SessionsController < ApplicationController
  def create
    @user = User.where(email: params[:username]).or(User.where(username: params[:username])).first
    console
    if !!@user && @user.authenticate(params[:password])
      reset_session
      session[:user_id] = @user.id
      session[:expires_at] = (Time.now + 3600).to_i
      redirect_to '/'
    else
      flash[:error] = 'No user or incorrect password!'
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
