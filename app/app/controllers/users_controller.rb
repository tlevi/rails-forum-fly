class UsersController < ApplicationController
  self.action_access_by_role = {
    guest:     %i[ create new ],
    member:    %i[ show edit update ],
    admin:     %i[ index ],
  }

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

  def index
    raise unless is_admin?
    @users = User.all
  end

  def show
    id = params.dig(:id)
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
    params.require(:user).permit(:id, :username, :password, :email, :role)
  end
end
