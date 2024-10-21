class PostsController < CrudController
  self.nesting = Topic

  self.action_access_by_role = {
    guest:  %i[ index show ],
    member: %i[ new create update edit ],
  }

  before_action :check_post_edit_permission, only: %i[ update edit ]
  before_action :set_topic, only: %i[ update edit ]

  def new
    @post.topic = @topic
  end

  def create
    ActiveRecord::Base.transaction do
      @topic = Topic.find(params.dig(:topic_id))
      @post = Post.create({
        body:   post_params[:body],
        topic_id:  @topic.id,
        forum_id:  @topic.forum.id,
        author: current_user,
      })
    end
    redirect_to topic_path(@topic)
  end

  def update
    @post.body = post_params[:body]
    @post.touch
    @post.save!
    redirect_to topic_path(@post.topic)
  end

private

  def set_topic
    @topic = @post.topic
    @forum = @topic.forum
  end

  def check_post_edit_permission
    raise unless can_edit?(@post)
  end

  def path_args(clazz)
    params.has_key?(:topic_id) ? super : ''
  end

  def model_scope
    params.has_key?(:topic_id) ? super : Post.all
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
