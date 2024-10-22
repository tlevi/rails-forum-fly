class PostsController < CrudController
  self.nesting = Topic

  self.action_access_by_role = {
    guest:  %i[ index show ],
    member: %i[ new create update edit ],
  }

  before_action :set_breadcrumbs

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
    @post.editor = current_user
    @post.touch
    @post.save!
    redirect_to topic_path(@post.topic)
  end

  def edit
    super
  end

private

  def topic
    if @post.present?
      @topic ||= @post.topic
    else
      @topic ||= Topic.find(params.dig(:topic_id))
    end
  end

  def set_breadcrumbs
    forum = topic.forum
    add_breadcrumb(forum.title, forum_path(forum))
    add_breadcrumb(topic.title, topic_path(topic))

    if @post.present?
      if @post.new_record?
        add_breadcrumb('New reply')
      else
        add_breadcrumb("#{action_name.capitalize} post")
      end
    end
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
