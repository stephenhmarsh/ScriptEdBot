class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.timestamps
      t.decimal :value
      t.belongs_to :pointable, polymorphic: true
      t.belongs_to :user
    end
  end
end
