module ApplicationHelper
  def bot_name
    @bot_name ||= (Settings.school_name.gsub(' ','') + 'Bot')
  end
end
