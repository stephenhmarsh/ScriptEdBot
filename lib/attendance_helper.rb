module AttendanceHelper

  def class_today?
   Settings.attendance.class_days.keys.include?(current_day_of_the_week)
  end

  def late?
    return late unless late.nil?
    context = created_at ? created_at : Time.now
    context >
  end

  def get_start_time_today
    Settings
      .attendance
      .class_days
      .send(current_day_of_the_week)
      .try(:start_time)
  end

  def current_day_of_the_week
    Time.now.strftime('%A').downcase.to_sym
  end
end
