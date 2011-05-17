class SubscriptionsController < InheritedResources::Base
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'
  
  def thanks
    @user = resource
    
    unless @user.nil?
      @user.subscription_id = params[:subscription_id]
      @user.save
      redirect_to territories_path, :flash => {:notice => "Great you're all setup, you'll start recieving calls at anytime"}
    else
      flash[:error] = "Sorry, we couldn't find your account, please contact us for assistance"
      redirect_to '/'
    end
  end

protected

  def resource
    @user = User.find(params[:customer_reference])
  end

end