class Attendance < ApplicationRecord
  before_validation :set_scheduled_start_time, on: :create
  before_validation :set_late, on: :create
  before_validation :issue_points, on: :create

  validates_presence_of :user, :ip_address, :browser
  validates_associated :point
  validate :there_is_class_today?, on: :create
  validate :attended_yet_today?, on: :create

  belongs_to :user

  has_one :point, as: :pointable, dependent: :destroy
  accepts_nested_attributes_for :point

  scope :created_today, -> { where("created_at >= :start_time AND created_at <= :end_time", {start_time: Date.today.beginning_of_day, end_time: Date.today.end_of_day}) }

  include ::AttendanceHelper

  def valid_attendance?
    there_is_class_today? && within_attendance_window? && !attended_yet_today?
  end

  def late?
    return set_late if new_record?
    late
  end

  def on_time?
    !late?
  end

  def there_is_class_today?
    if Settings.attendance.class_days.keys.include?(current_day_name)
      true
    else
      errors.add(:no_class_today, message: "Thanks for logging in, but there's no class today!")
      false
    end
  end

  def within_attendance_window?
    (Time.now >= Settings.attendance.attendance_threshold.start.minutes &&
      Time.now <= Settings.attendance.attendance_threshold.end.minutes)
  end

  def attended_yet_today?
    if user.attendances.created_today.count > 0
      errors.add(:already_attended, message: "Thanks for logging in, but you've already attended class today. No points. :(")
      true
    else
      false
    end
  end

  private

  def add_attendance_points
    point.value += 1 if valid_attendance?
  end

  def add_punctuality_points
    point.value += 1 if on_time?
  end

  def set_late
    late = there_is_class_today? && Time.now > (scheduled_start_time + Settings.attendance.lateness_threshold.minutes)
  end

  def set_scheduled_start_time
    scheduled_start_time = get_start_time_today
  end

  def issue_points
    if there_is_class_today? && !attended_yet_today?
      point = Point.new
      add_attendance_points
      add_punctuality_points
    end
  end
end
