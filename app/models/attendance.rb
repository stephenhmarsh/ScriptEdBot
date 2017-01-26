class Attendance < ActiveRecord::Base
  has_one :point, as: :pointable
end
