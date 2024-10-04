class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if User.where(username: user_params[:username]).or(User.where(email: user_params[:email])).exists?
      flash[:error] = 'Username or email is already taken!'
      render :new
    end
    @user = User.new(user_params)
    @user.role = 'member'
    if params[:password_confirm] != params[:password]
      flash[:error] = 'Passwords do not match!'
      render :new
    end
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params.dig(:id))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = @current_user
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :username, :password, :email, :role)
  end
end
