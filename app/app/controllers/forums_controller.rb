class ForumsController < CrudController
  self.permitted_attrs = [:title, :description]

  self.action_access_by_role = {
    guest:  %i[ index ],
    member: %i[ show ],
    admin:  %i[ new create edit update ],
  }

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
    @forums = Forum.order(id: :asc)
  end

  def show
    @forum = Forum.find(params.dig(:id))
  end

private

  def check_action_by_role(action, role)
    super
  end
end
