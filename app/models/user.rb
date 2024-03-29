class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
  
  attr_accessible :email, :password, :password_confirmation, :approved_by_admin

  #has_many :time_records
  has_one :time_record, dependent: :destroy
  
end
