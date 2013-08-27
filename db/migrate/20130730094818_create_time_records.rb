class CreateTimeRecords < ActiveRecord::Migration
  def change
    create_table :time_records do |t|

      t.integer :user_id
      t.date :date
      t.time :in_time
      t.time :out_time
      t.time :attended_hours
      t.time :total_hours
      t.text :current_month_timing

      t.timestamps
    end
  end
end
