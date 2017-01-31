class AddStuffToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :browser, :string
  end
end
