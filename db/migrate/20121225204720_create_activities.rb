class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.boolean :chargeable
      t.integer :user_id

      t.timestamps
    end
    add_index :activities, :name, :unique => true
    add_index :activities, :user_id
  end
end
