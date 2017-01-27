class AddClassTimeToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :class_start_time, :timestamp
  end
end
