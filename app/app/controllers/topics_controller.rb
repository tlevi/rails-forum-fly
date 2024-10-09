class TopicsController < CrudController
  self.nesting = Forum

  self.action_access_by_role = {
    guest:  %i[ index show ],
    member: %i[ new create update ],
  }

  def index
    @forum = Forum.find(params.dig(:forum_id))
    @topics = @forum.topics
  end

  def new
    super
  end

private

#  def get_forum
#    @forum = Forum.find(params.dig(:forum_id))
#  end

#  def set_topic
#    @topic = @forum.posts.find(params.dig(:id))
#  end

  def topic_params
    params.require(:topic).permit(:post_body)
  end
end
