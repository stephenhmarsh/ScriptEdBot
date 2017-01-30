  module AttendanceHelper

    def get_start_time_today
      Settings
        .attendance
        .class_days
        .send(current_day_name)
        .try(:start_time)
    end

    def current_day_name
      Time.now.strftime('%A').downcase.to_sym
    end
  end

