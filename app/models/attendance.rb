class Attendance < ActiveRecord::Base
  after_initialize :set_class_start_time
  before_commit :issue_points, on: :create
  has_one :point, as: :pointable, dependent: :destroy

  private

  def set_class_start_time
    class_start_time ? class_start_time : start_time_today
  end

  def issue_points
    # Point.create(value:)
  end
end
