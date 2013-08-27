class AddColumnsToTimeRecords < ActiveRecord::Migration
  def change
    add_column :time_records, :updated_previous_month_data, :boolean, default: false
    add_column :time_records, :updated_later_month_data, :boolean, default: false
  end
end
