module ApplicationHelper
  def bot_name
    @bot_name ||= (Settings.school.name.gsub(' ','') + 'Bot')
  end

  def pretty_browser(user_agent_string)
   [UserAgent.parse(user_agent_string).browser, UserAgent.parse(user_agent_string).platform].join(', ')
  end
end
