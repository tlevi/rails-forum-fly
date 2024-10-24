module UsersHelper
  def try_login_user(user, password)
    return false if !user or !user.authenticate(password)
    reset_session
    session[:user_id] = user.id
    session[:expires_at] = (Time.now + 3600).to_i
    true
  end
end
