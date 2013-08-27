class TimeRecord < ActiveRecord::Base
  attr_accessible :date, :in_time, :out_time, :user_id, :attended_hours, :total_hours, :current_month_timing,
    :previous_month_data, :later_month_data, :updated_previous_month_data, :updated_later_month_data

  belongs_to :user

  #  validates :date, presence: {message: "required field cannot be blank"}
  #  validates :in_time, presence: {message: "required field cannot be blank"}
  #  validates :out_time, presence: {message: "required field cannot be blank"}


  def self.update_privious_month_timing(user, current_month_timings)
    #self.update_attributes(updated_previous_month_data: true)
    record = self.where("user_id = ? ", user.id).first
    record.update_attributes(previous_month_data: current_month_timings, updated_previous_month_data: true )
  end

  def self.update_current_month_timing(user, current_month_timings)
    msg = false
    record = self.where("user_id = ? ", user.id).first
    if record.update_attributes(current_month_timing: current_month_timings)
      msg = true
    else
      msg = false
    end

    return msg
  end

  def self.create_new_time_record(user_id, current_month_timings)
    msg = false
    if self.create(user_id: user_id, current_month_timing: current_month_timings)
      msg = true
    else
      msg = false
    end

    return msg
  end
  
end
