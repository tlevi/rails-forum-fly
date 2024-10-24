class UsersController < ApplicationController
  include UsersHelper

  self.action_access_by_role = {
    guest:     %i[ create new ],
    member:    %i[ show edit update ],
    admin:     %i[ index ],
  }

  def new
    add_breadcrumb 'Create account'
    @user = User.new
  end

  def create
    if params[:password_confirm] != params[:password]
      flash[:error] = 'Passwords do not match!'
      render :new, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      @user = User.create(user_params.slice(:username, :preferredname, :password, :password_confirmation, :email))
      @user.role = 'member'
      if @user.save
        @user.reload
        if try_login_user(@user, user_params[:password])
          flash[:success] = 'Account created, welcome!'
          redirect_to root_path
        else
          flash[:error] = 'Error logging in new account'
          redirect_to login_path
        end
      else
        flash[:error] = 'Error creatng user record'
        render :new, status: :unprocessable_entity
      end
    end
  end

  def index
    raise unless is_admin?
    @users = User.all
  end

  def show
    id = params.dig(:id).to_i
    raise unless is_admin? or current_user.id == id

    @user = current_user
    @user = User.find(params.dig(:id))
  end

  def edit
    id = params.dig(:id)
    raise unless is_admin? or current_user.id == id

    @user = User.find(params[:id])
  end

  def update
    id = params.dig(:id)
    raise unless is_admin? or current_user.id == id

    @user = @current_user
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :username, :password, :password_confirmation, :preferredname, :email, :role)
  end
end
