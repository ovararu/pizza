class RoutesController < InheritedResources::Base
  defaults :resource_class => Route, :collection_name => 'routes', :instance_name => 'route'
 
  respond_to :json, :only => [:create, :update, :destroy]
  respond_to :html, :only => [:show]
  
  actions :show, :create, :update, :destroy

  before_filter :authenticate_user!


  def show
    @route = resource
    render :partial => 'show'
  end

  def create
    @route = Route.new(params[:route])
    @route.user = current_user
    create!
  end
  
  # weird
  update! do |success, failure|
    success.json { render :json => resource.to_json, :status => :ok }
    failure.json { render :json => resource.errors.to_json, :status => :unprocessable_entity }
  end
    
  def destroy
    @route = resource
    @route.delete
    json = @route.to_json
    @route.save
    render :json => json
  end

protected
  
  def collection
    @routes || set_collection_ivar(Route.all)
  end
  
  
end