class HomeController < ApplicationController

  before_filter :authenticate_user!, except: [ :index, :about_us, :instructions, :contact ]

  def index
    @user = current_user
  end

  def dashboard
    @user = current_user
  end

  def about_us
    
  end

  def instructions

  end

  def contact

  end
  
end
