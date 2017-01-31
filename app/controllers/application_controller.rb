class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_browser
    @current_browser ||= [UserAgent.parse(request.user_agent).browser,
      UserAgent.parse(request.user_agent).platform].join(', ')
  end
end
