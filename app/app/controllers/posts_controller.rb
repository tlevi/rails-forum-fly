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
      if @topic.id == session.dig(:posted_to) && Time.now.to_i - session.dig(:posted_new).to_i < 60
        flash[:warning] = 'Please wait at least 1 minute before posting in the same topic!'
        render :new, status: :unprocessable_entity
        return
      end
      @topic.touch
      @post.save!
    rescue
      flash[:error] = 'Post details are invalid!'
      render :new, status: :unprocessable_entity
      return
    end

    session[:posted_to]  = @post.topic.id
    session[:posted_at]  = Time.now.to_i
    session[:posted_new] = Time.now.to_i
    redirect_to topic_path(@topic)
  end

  def update
    @post.body = post_params[:body]
    @post.editor = current_user
    @post.touch
    @post.save!
    session[:posted_to] = @post.topic.id
    session[:posted_at] = Time.now.to_i
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
