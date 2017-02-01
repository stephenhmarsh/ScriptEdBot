module AttendanceHelper

  def start_hour
    Settings
      .attendance
      .class_days
      .send(current_day_name)
      .try(:hour)
  end

  def start_minute
    Settings
      .attendance
      .class_days
      .send(current_day_name)
      .try(:minute)
  end

  def build_start_time
    Time.new(
      Date.today.year,
      Date.today.month,
      Date.today.day,
      start_hour,
      start_minute,
      0)
  end

  def current_day_name
    Time.now.strftime('%A').downcase.to_sym
  end
end
