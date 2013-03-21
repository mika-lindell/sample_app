class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    # Add index since we need to retrieve users by token
    add_index  :users, :remember_token
  end
end
