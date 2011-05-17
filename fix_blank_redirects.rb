
# users misse redirection...
User.where(:subscription_id => nil).all do |user|
  
  subscription = Chargify::Subscription.find_by_customer_reference(user.id)
  unless subscription.nil?
    user.update_attributes!(:subscription_id => customer[:subscription_id])
  end
  
end

