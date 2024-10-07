module ApplicationHelper
  def session_user_id
    return session[:user_id]&.nonzero? ? session[:user_id] : 1
  end

  def logged_in?
    return session_user_id > 1
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
    session = [] if @current_user.nil?
    return @current_user
  end

  def is_admin?
    return current_user&.role == 'admin'
  end

  def is_moderator?
    return current_user&.role == 'moderator'
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
end
