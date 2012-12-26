class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :activity_id
      t.datetime :ticker_start_at
      t.datetime :ticker_end_at
      t.integer :duration
      t.date :executed_on
      t.text :description

      t.timestamps
    end
    add_index :entries, :user_id
    add_index :entries, :project_id
    add_index :entries, :activity_id
  end
end
