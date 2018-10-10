class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    #adds a default value if nil or none is present while seeing
    # admin: f is the default value for admin: nil columns
  end
end
