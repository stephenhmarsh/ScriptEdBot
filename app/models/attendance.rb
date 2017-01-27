class Attendance < ActiveRecord::Base
  before_create :set_scheduled_start_time
  before_create :set_late
  before_create :issue_points

  has_one :point, as: :pointable, dependent: :destroy

  def late?
    late.nil? ? set_late : late
  end

  private

  def set_late
    late = Time.now > (scheduled_start_time + Settings.attendance.lateness_threshold.minutes)
  end

  def set_scheduled_start_time
    scheduled_start_time = get_start_time_today
  end

  def issue_points
    if class_today?
      point = Point.new(value: 1)
      point.value += 1 unless late?
    end
  end
end
