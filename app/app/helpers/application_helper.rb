module ApplicationHelper
  def session_user_id
    return session[:user_id]&.nonzero? ? session[:user_id] : 1
  end

  def logged_in?
    return session_user_id > 1
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session.has_key?(:user_id)
    @current_user ||= User.find_by_id!(1)
  end

  def is_guest?
    !is_member?
  end

  def is_member?
    return current_user.role == 'member' || is_moderator?
  end

  def is_moderator?
    return current_user.role == 'moderator' || is_admin?
  end

  def is_admin?
    return current_user.role == 'admin'
  end

  def can_edit?(model)
    if model.author.blank? or current_user.id == model.author.id or is_moderator?
      true
    else
      false
    end
  end

  def flash_class(level)
    case level
      when 'success' then "alert alert-dismissible fade show alert-server alert-success"
      when 'notice'  then "alert alert-dismissible fade show alert-server alert-info"
      when 'info'    then "alert alert-dismissible fade show alert-server alert-info"
      when 'alert'   then "alert alert-dismissible fade show alert-server alert-warning"
      when 'error'   then "alert alert-dismissible fade show alert-server alert-danger"
      else 'alert alert-dismissible fade show alert-server alert-info'
    end
  end

  def friendly_action_name
    case action_name
      when 'new'  then "Create #{controller_name.singularize}"
      when 'edit' then 'Save changes'
      else "#{action_name.capitalize} #{controller_name.singularize}"
    end
  end
end
