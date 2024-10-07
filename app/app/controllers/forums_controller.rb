class ForumsController < ApplicationController
  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new(forum_params)
    if @forum.save
      flash[:success] = "New forum '#{@forum.title}' created!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @forums = Forum.all
  end

  def show
    @forum = Forum.find(params.dig(:id))
  end

  def edit
    @forum = Forum.find(params[:id])
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

  def forum_params
    params.require(:forum).permit(:title, :description)
  end
end
