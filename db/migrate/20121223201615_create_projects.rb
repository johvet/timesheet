class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, :null => false
      t.integer :customer_id, :null => false
      t.integer :user_id, :null => false
      t.text :comment

      t.timestamps
    end
    add_index :projects, :title, :unique => true
    add_index :projects, :customer_id, :name => "project_belongs_to_customer"
    add_index :projects, :user_id, :name => "project_belongs_to_user"
  end
end
