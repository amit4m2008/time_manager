
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              "smtp.gmail.com",
  port:                 587,
  domain:               "admin@timemanager.com",
  user_name:            "officetimemanager@gmail.com",
  password:             "admin!@#45",
  authentication:       "plain",
  enable_starttls_auto: true
}

# Example of Settings
# ActionMailer::Base.smtp_settings = {
# 	:user_name => "send grid user name",
# 	:password => "sendgrid password",
# 	:domain => "your domain name",
# 	:address => "smtp.sendgrid.net",
# 	:port => 25,
# 	:authentication => :plain,
# 	:enable_starttls_auto => true
# }
