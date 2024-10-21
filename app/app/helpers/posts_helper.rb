module PostsHelper
  def save_post_path(topic, post)
    case action_name
      when 'new', 'create'
        topic_posts_path(topic)
      when 'edit', 'update'
        post_path(post)
      else
        raise :abort
    end
  end
end
