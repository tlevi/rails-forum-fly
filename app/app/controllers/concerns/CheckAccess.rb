module CheckAccess
  extend ActiveSupport::Concern

  included do
    before_action   :check_access
    class_attribute :action_access_by_role, default: {}
  end

  protected

    def check_action_by_role(action, role)
      action = action.to_sym
      return true if action_access_by_role.dig(role.to_sym)&.include?(action)
      return true if is_admin? && action_access_by_role.dig(:moderator)&.include?(action)
      return true if is_moderator? && action_access_by_role.dig(:member)&.include?(action)
      return true if action_access_by_role.dig(:guest)&.include?(action)
      return false
    end

  private

    def check_access
      render_no_access unless check_action_by_role(action_name, current_user.role)
    end

    def render_no_access
      render :file => 'public/403.html', :status => :forbidden, layout: false unless performed?
      false
    end
end
