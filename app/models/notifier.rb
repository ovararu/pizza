class Notifier < ActionMailer::Base
  default_url_options[:host] = "test-pizzarouter.heroku.com"

  # user emails
  def welcome(user)
    setup(user)
    subject I18n.t("subject.welcome")
    body :user => user, :welcome_url => user_root_url
  end

  def activation_instructions(user)
    setup(user)
    subject I18n.t("subject.activation_instructions")
    body :activation_link => activate_activation_url(user.perishable_token)
  end

  def password_instructions(user)
    setup(user)
    subject I18n.t("subject.password_instructions")
    body :password_link => activate_password_url(user.perishable_token)
  end

  # order emails
  def receipt(order)
    setup(order.user)
    subject I18n.t("subject.receipt")
  end

  def processed(order)
    setup(order.user)
    subject I18n.t("subject.processed")
  end

  private

    def setup(user)
      from "do-not-reply@test-pizzarouter.heroku.com"
      sent_on Time.now
      recipients user.email
    end

end