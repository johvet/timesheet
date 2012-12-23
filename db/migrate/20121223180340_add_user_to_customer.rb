class AddUserToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :user_id, :integer

    add_index :customers, [:user_id], :name => "customer_belongs_to_user_index"
    add_index :customers, [:name], :unique => true, :name => "customer_name_is_unique_index"
  end
end
