class UserMailer < ActionMailer::Base
  default from: "ADMIN <officetimemanager@gmail.com>"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Time Manager") do |format|
      format.html
    end
  end

  def approved(user)
    @user = user
    mail(to: @user.email, subject: "Approval from the Time Manager admin") do |format|
      format.html
    end
  end

  def rejected(user)
    @user = user
    mail(to: @user.email, subject: "Rejection from the Time Manager admin") do |format|
      format.html
    end
  end
  
end
