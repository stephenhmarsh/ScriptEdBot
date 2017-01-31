class Attendance < ApplicationRecord
  before_validation :get_start_time, on: :create
  before_validation :set_late, on: :create
  before_validation :issue_points, on: :create

  validates_presence_of :user, :ip_address, :browser
  validates_associated :point
  validate :there_is_class_today?, on: :create
  validate :attended_yet_today?, on: :create

  belongs_to :user

  has_one :point, as: :pointable, dependent: :destroy
  accepts_nested_attributes_for :point

  scope :created_today, -> { where("created_at >= :start_time AND created_at <= :end_time", {start_time: Time.now.beginning_of_day, end_time: Time.now.end_of_day}) }

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
    not_too_early = Time.now >= (get_start_time - 45.minutes)
    not_too_late = Time.now <= (get_start_time + 30.minutes)
    errors.add(:too_late, message: "Sorry but you're too late for class to count as attendance. :(") unless not_too_late
    errors.add(:too_early, message: "Sorry but you're too early for class, try later.") unless not_too_early
    return (not_too_early && not_too_late)
  end

  def attended_yet_today?
    if user.attendances.created_today.count > 0
      errors.add(:already_attended, message: "Thanks for logging in, but you've already attended class today. No points. :(")
      true
    else
      false
    end
  end

  def minutes_late
    ((created_at - scheduled_start_time) / 60).to_i
  end

  private

  def add_attendance_points
    100.times { logger.info "running add_attendance - #{valid_attendance?}"}
    100.times { logger.info "#{there_is_class_today?} && #{within_attendance_window?} && #{!attended_yet_today?}"}
    self.point.value += 1 if valid_attendance?
  end

  def add_punctuality_points
    self.point.value += 1 if (valid_attendance? && on_time?)
  end

  def set_late
    self.late = Time.now > (get_start_time + Settings.attendance.lateness_threshold.minutes)
  end

  def get_start_time
    self.scheduled_start_time ||=
      Time.new(Date.today.year, Date.today.month, Date.today.day, start_hour, start_minute)
  end

  def issue_points
    if there_is_class_today? && !attended_yet_today?
      self.point = Point.new(pointable: self, value: 0)
      add_attendance_points
      add_punctuality_points
    end
  end
end
