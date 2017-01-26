class CreateAttendance < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.timestamps
      t.references :user
      t.text :ip_address
    end
  end
end
