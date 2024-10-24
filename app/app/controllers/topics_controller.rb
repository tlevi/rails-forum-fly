class TopicsController < CrudController
  self.nesting = Forum

  # TODO: Updates need to be limited further for members in the actual method
  self.action_access_by_role = {
    guest:     %i[ index show list ],
    member:    %i[ new create update edit ],
  }

  before_action :set_breadcrumbs, except: :list

  def index
    @topics = forum.topics
    # Arbitrary limit in lieu of paging.
    @topics = @topics.limit(20)
    setup_topic_list(@topics)
  end

  def list
    pick = params.dig(:pick)
    add_breadcrumb("#{pick.capitalize} topics", "/topics/list/#{pick}")
    @topics = case pick
      when 'fresh' then Topic.order(created_at: :desc)
      when 'active' then Topic.order(reply_count: :desc)
      when 'popular' then Topic.order(view_count: :desc)
      else throw :abort
    end
    # Arbitrary limit in lieu of paging.
    @topics = @topics.limit(20)
    setup_topic_list(@topics)
  end

  def new
    post = Post.new
    @topic.first_post = Post.new
  end

  def create
    ActiveRecord::Base.transaction do
      @post = Post.create({
        body:   post_params[:body],
        forum:  forum,
        author: current_user,
      })

      @topic = Topic.create(topic_params.merge({
        forum:      forum,
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

  def show
    if Time.now.to_i - session.dig(:posted_at).to_i > 30
      Topic.increment_counter(:view_count, entry.id)
    end
    ActiveRecord::Associations::Preloader.new(records: [entry], associations: {posts: :author}).call
  end

private

  def setup_topic_list(topic_scope)
    pt = Post.arel_table
    @topic_last_posts = Post.find_by_sql(
      pt.project(pt[Arel.star])
        .where(pt[:forum_id].in(topic_scope.load.pluck(:forum_id)))
        .distinct_on(pt[:topic_id])
        .order(pt[:topic_id], pt[:created_at].desc, pt[:id].desc)
    )

    ActiveRecord::Associations::Preloader.new(records: topic_scope, associations: [:author, :forum]).call
    ActiveRecord::Associations::Preloader.new(records: @topic_last_posts, associations: [:author, :editor]).call

    @topic_last_posts = @topic_last_posts.group_by(&:topic_id)
  end

  def set_breadcrumbs
    add_breadcrumb(forum.title, forum_path(forum))

    if @topic.present?
      if @topic.new_record?
        add_breadcrumb('Post new topic')
      else
        add_breadcrumb(@topic.title, topic_path(@topic))
      end
    end
  end

  def forum
    if @topic.present?
      @forum ||= @topic.forum
    else
      @forum ||= Forum.with_all_rich_text.find(params.dig(:forum_id))
    end
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
