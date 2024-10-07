class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :info

  before_action :expire_session

  private
    def expire_session
      if logged_in? and current_user.nil?
        reset_session
        redirect_to root_path
      end
      if session[:user_id].present?
        now = Time.now.to_i
        if now > session[:expires_at].to_i
          reset_session
          redirect_to root_path
        else if session[:expires_at].to_i - now < (3600 - 300)
          # Extend the session at least once per 5 minutes.
          session[:expires_at] = now + 3600
        end
      end
    end
  end
end
