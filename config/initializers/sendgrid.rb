ActionMailer::Base.smtp_settings = {
  :address        => "smtp.sendgrid.net",
  :port           => "25",
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'] || 'app455819@heroku.com',
  :password       => ENV['SENDGRID_PASSWORD'] || 'd03cb6555b2b05755b',
  :domain         => ENV['SENDGRID_DOMAIN']   || 'heroku.com'
}
