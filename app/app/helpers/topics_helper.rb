module TopicsHelper
private

  def save_topic_path(forum, topic)
    case action_name
      when 'new', 'create'
        forum_topics_path(forum)
      when 'edit', 'update'
        topic_path(topic)
      else
        raise :abort
    end
  end
end
