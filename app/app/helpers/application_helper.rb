module ApplicationHelper
  def session_user_id
    session[:user_id]&.nonzero? ? session[:user_id] : 1
  end

  def logged_in?
    session_user_id > 1
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def is_admin?
    current_user.role
  end

  def flash_class(level)
    case level
      when 'notice'  then "alert alert-dismissible fade show alert-server alert-info"
      when 'success' then "alert alert-dismissible fade show alert-server alert-success"
      when 'error'   then "alert alert-dismissible fade show alert-server alert-danger"
      when 'alert'   then "alert alert-dismissible fade show alert-server alert-warning"
      else raise 'invalid level!'
    end
  end
end
