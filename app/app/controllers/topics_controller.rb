class TopicsController < CrudController
  self.nesting = Forum

  # TODO: Updates need to be limited further for members in the actual method
  self.action_access_by_role = {
    guest:     %i[ index show ],
    member:    %i[ new create update edit ],
  }

  before_action :check_topic_edit_permission, only: %i[ update edit ]
  before_action :set_forum, only: %i[ update edit ]

  def index
    @forum = Forum.find(params.dig(:forum_id))
    @topics = @forum.topics.includes(:author)

    pt = Post.arel_table
    @topic_first_posts = Post.find_by_sql(
      pt.project(pt[Arel.star])
        .where(pt[:forum_id].eq(@forum.id))
        .distinct_on(pt[:topic_id])
        .order(pt[:topic_id], pt[:created_at].desc, pt[:id].desc)
    )

    ActiveRecord::Associations::Preloader.new(records: @topic_first_posts, associations: :author).call
    @topic_first_posts = @topic_first_posts.group_by(&:topic_id)

    @topic_post_counts = Post.where(forum_id: @forum.id).group(:topic_id).count
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

  def check_topic_edit_permission
    raise unless can_edit?(@topic)
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
