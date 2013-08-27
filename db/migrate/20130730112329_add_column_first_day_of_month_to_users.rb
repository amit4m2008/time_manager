class AddColumnFirstDayOfMonthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_day_of_month, :integer, default: 25
  end
end
