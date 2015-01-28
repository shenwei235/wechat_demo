module ApplicationHelper
  def current_user
    warden.user
  end
end
