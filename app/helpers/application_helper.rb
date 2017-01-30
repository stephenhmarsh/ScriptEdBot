module ApplicationHelper
  def bot_name
    @bot_name ||= (Settings.school.name.gsub(' ','') + 'Bot')
  end
end
