class AdminsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authenticate_admin

  def index
    @total_users = User.where("admin = ?", false).order("email ASC")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def approve_user
    @user = User.find(params[:id])
    @user.update_attributes( approved_by_admin: true )
    UserMailer.approved(@user).deliver unless @user.invalid?

    respond_to do |format|
      format.html{ redirect_to admins_path }
    end
  end

  def reject_user
    @user = User.find(params[:id])
    @user.update_attributes( approved_by_admin: false )
    UserMailer.rejected(@user).deliver unless @user.invalid?
    
    redirect_to admins_path
    #respond_to do |format|
    #  format.html{ redirect_to admins_path }
    #end
  end

  def destroy_user
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admins_path
    #respond_to do |format|
    #  format.html{ redirect_to admins_path }
    #end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html{ redirect_to admins_path }
    end
  end
  
end
