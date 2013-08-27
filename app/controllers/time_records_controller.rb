class TimeRecordsController < ApplicationController

  require 'time_diff'
  
  before_filter :authenticate_user!
  before_filter :authenticate_user_aprooval
    
  def index
    if !current_user.blank? && current_user.admin
      redirect_to admins_path
    else
    
      unless current_user.time_record.current_month_timing.blank?
        @current_time_records = ActiveSupport::JSON.decode(current_user.time_record.current_month_timing).to_hash
        @previous_time_records = ActiveSupport::JSON.decode(current_user.time_record.previous_month_data).to_hash
      end
      
    end
  end

  def new
    record = TimeRecord.where("user_id = ? ", current_user.id).first
    
    if record.current_month_timing.blank?
      render action: "new"
    else
      redirect_to edit_multiple_time_records_path
    end
  end

  def edit_multiple
    if current_user.time_record.blank?
      render action: "new"
    else
      @time_records = ActiveSupport::JSON.decode(current_user.time_record.current_month_timing).to_hash
    end
  end

  def update_multiple

    total_hours = "09:00"

    user_fday = current_user.first_day_of_month

    month = 1
    i = 1

    if user_fday <= Date.today.day
      month =  Date.today.month
    else
      month =  Date.today.month - 1
    end
    sdate =  Date.new(2013, month, user_fday)
    
    (sdate..Date.today).each do |date|
      unless DateTime.parse("#{date}").strftime("%A") == "Saturday" || DateTime.parse("#{date}").strftime("%A") == "Sunday"
        if  params[:time_record][:current_month_timing]["#{i}"][:in_time].blank? || params[:time_record][:current_month_timing][i.to_s][:out_time].blank?
          params[:time_record][:current_month_timing]["#{i}"].merge!(:attended_hours => "", :total_hours => total_hours)
        else
          attended_hours = Time.diff(Time.parse(params[:time_record][:current_month_timing]["#{i}"][:out_time]), Time.parse(params[:time_record][:current_month_timing]["#{i}"][:in_time]), "%h:%m")
          params[:time_record][:current_month_timing]["#{i}"].merge!(:attended_hours => attended_hours[:diff], :total_hours => total_hours)
        end
        i += 1
      end
    end
    i = 1
    params[:time_record].merge!(:user_id => current_user.id)

    params[:time_record][:current_month_timing] = params[:time_record][:current_month_timing].to_json


    record = TimeRecord.where("user_id = ? ", current_user.id).first
    if record.blank?
      if TimeRecord.create(user_id: params[:time_record][:user_id], current_month_timing: params[:time_record][:current_month_timing])
        flash[:notice] = "create success"
        redirect_to time_records_path
      else
        flash[:notice] = "create error"
        redirect_to edit_multiple_time_records_path
      end
    else
      if record.update_attributes(current_month_timing: params[:time_record][:current_month_timing])
        unless record.updated_previous_month_data
          time_record = record.current_month_timing
          user_fday = current_user.first_day_of_month
          if (Date.today.day == user_fday - 1)
            TimeRecord.update_privious_month_timing(current_user, time_record)
          end
        end
        if Date.today.day == user_fday + 1
          record.update_attributes(updated_previous_month_data: false)
        end
          
        flash[:notice] = "Update success"
        redirect_to time_records_path
      else
        flash[:notice] = "Update error"
        redirect_to edit_multiple_time_records_path
      end
    end

  end

  def create_multiple

    total_hours = "09:00"
    user_fday = current_user.first_day_of_month
    month = 1
    i = 1

    if user_fday <= Date.today.day
      month =  Date.today.month
    else
      month =  Date.today.month - 1
    end
    sdate =  Date.new(2013, month, user_fday)

    (sdate..Date.today).each do |date|
      unless DateTime.parse("#{date}").strftime("%A") == "Saturday" || DateTime.parse("#{date}").strftime("%A") == "Sunday"
        if  params[:time_record][:current_month_timing]["#{i}"][:in_time].blank? || params[:time_record][:current_month_timing][i.to_s][:out_time].blank?
          params[:time_record][:current_month_timing]["#{i}"].merge!(:attended_hours => "", :total_hours => total_hours)
        else
          attended_hours = Time.diff(Time.parse(params[:time_record][:current_month_timing]["#{i}"][:out_time]), Time.parse(params[:time_record][:current_month_timing]["#{i}"][:in_time]), "%h:%m")
          params[:time_record][:current_month_timing]["#{i}"].merge!(:attended_hours => attended_hours[:diff], :total_hours => total_hours)
        end
        i += 1
      end
    end
    i = 1
    params[:time_record].merge!(:user_id => current_user.id)
    
    params[:time_record][:current_month_timing] = params[:time_record][:current_month_timing].to_json

    record = TimeRecord.where("user_id = ? ", current_user.id).first
    if record.blank?
      msg = TimeRecord.create_new_time_record(params[:time_record][:user_id], params[:time_record][:current_month_timing])
    else
      msg = TimeRecord.update_current_month_timing(current_user, params[:time_record][:current_month_timing])
    end
    
    if msg
      flash[:notice] = "Update success"
      redirect_to time_records_path
    else
      flash[:notice] = "Update error"
      redirect_to edit_multiple_time_records_path
    end

  end

  def edit_previous_month_timings
    unless current_user.time_record.previous_month_data.blank?
      @previous_time_records = ActiveSupport::JSON.decode(current_user.time_record.previous_month_data).to_hash
    end
  end

  def update_previous_month_timings
    
    total_hours = "09:00"
    first_index = params[:time_record][:previous_month_timing].keys.first.to_s
    
    fd = params[:time_record][:previous_month_timing][first_index]["date"].to_date
    ld = params[:time_record][:previous_month_timing][first_index]["date"].to_date + 30
    i = 1
    
    (fd..ld).each do |date|
      unless DateTime.parse("#{date}").strftime("%A") == "Saturday" || DateTime.parse("#{date}").strftime("%A") == "Sunday"
        if  params[:time_record][:previous_month_timing]["#{i}"][:in_time].blank? || params[:time_record][:previous_month_timing][i.to_s][:out_time].blank?
          params[:time_record][:previous_month_timing]["#{i}"].merge!(:attended_hours => "", :total_hours => total_hours)
        else
          attended_hours = Time.diff(Time.parse(params[:time_record][:previous_month_timing]["#{i}"][:out_time]), Time.parse(params[:time_record][:previous_month_timing]["#{i}"][:in_time]), "%h:%m")
          params[:time_record][:previous_month_timing]["#{i}"].merge!(:attended_hours => attended_hours[:diff], :total_hours => total_hours)
        end
        i += 1
      end
    end
    params[:time_record].merge!(:user_id => current_user.id)

    params[:time_record][:previous_month_timing] = params[:time_record][:previous_month_timing].to_json

    #raise params[:time_record][:previous_month_timing].inspect
    record = TimeRecord.where("user_id = ? ", current_user.id).first
    if record.update_attributes(previous_month_data: params[:time_record][:previous_month_timing])
      flash[:notice] = "Update success"
      redirect_to time_records_path(previous: true)
    else
      flash[:notice] = "Update error"
      redirect_to edit_multiple_time_records_path
    end
    
  end

end