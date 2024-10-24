class SessionsController < ApplicationController
  include UsersHelper

  def create
    @user = User.where(email: params[:username]).or(User.where(username: params[:username])).first
    if try_login_user(@user, params[:password])
      redirect_to root_path
    else
      flash[:error] = 'No user or incorrect password!'
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  def login
    add_breadcrumb 'Log in'
  end

  private

  def check_edit_permission
    true
  end

  def check_action_by_role(action, role)
    true
  end
end
