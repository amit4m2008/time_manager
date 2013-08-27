class AddColumnApprovedByAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved_by_admin, :boolean, default: false
  end
end
