class TopicsController < CrudController
  self.nesting = Forum

  # TODO: Updates need to be limited further for members in the actual method
  self.action_access_by_role = {
    guest:     %i[ index show ],
    member:    %i[ new create update edit ],
  }

  before_action :check_topic_edit_permission, only: %i[ edit update ]
  before_action :set_forum, only: %i[ edit update ]

  def index
    @forum = Forum.find(params.dig(:forum_id))
    @topics = @forum.topics.merge(Post.with_rich_text_body)
  end

  def new
    post = Post.new
    @topic.first_post = Post.new
  end

  def create
    ActiveRecord::Base.transaction do
      @forum = Forum.find(params.dig(:forum_id))

      @post = Post.create({
        body:   post_params[:body],
        forum:  @forum,
        author: current_user,
      })

      @topic = Topic.create(topic_params.merge({
        forum:      @forum,
        author:     current_user,
        first_post: @post,
      }))
    end
   redirect_to topic_path(@topic)
  end

  def update
    post = @topic.first_post
    post.body = post_params[:body]
    post.touch
    @topic.save!
    redirect_to topic_path(@topic)
  end

private

  def set_forum
    @forum = @topic.forum
  end

  # TODO: Belongs elsewhere so we can use consistently in view etc
  def check_topic_edit_permission
    raise unless @topic.author.blank? or current_user.id == @topic.author.id or is_moderator?
  end

  def path_args(clazz)
    params.has_key?(:forum_id) ? super : ''
  end

  def model_scope
    params.has_key?(:forum_id) ? super : Topic.all
  end

  def topic_params
    params.require(:topic).permit(:title)
  end

  def post_params
    params.require(:topic).permit(:body)
  end
end
