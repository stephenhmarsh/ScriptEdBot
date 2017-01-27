class AddLateToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :late, :boolean
  end
end
