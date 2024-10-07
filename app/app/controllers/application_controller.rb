class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :info

  before_action :maybe_expire_session
  before_action :maybe_reset_app

  private
    def maybe_expire_session
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

    def maybe_reset_app
      # IMPORTANT: PLEASE don't try to do this in a Real(TM) app, ever...
      # TODO: Determine conditions to run this based on last run time.
      # TODO: Basically we want to emulate as-if a cron did it overnight, without running cron.
      #%x[rake db:seed:replant]
      #reset_session
      #redirect_to root_path
    end
  end
end
