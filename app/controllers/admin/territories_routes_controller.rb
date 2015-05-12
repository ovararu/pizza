class Admin::TerritoriesRoutesController < ApplicationController
  before_filter :authenticate_admin!
  
  layout 'admin'
  
  active_scaffold :route do |config|
    config.columns[:territory].form_ui = :record_select
    
    config.columns        = columns = [
      :marked, 
      :dst,
      :territory,
      :user,
      :created_at,
      :updated_at,
    ]
    
    
    config.actions << :config_list

    config.config_list.default_columns = [
      :marked, 
      :dst,
      :territory,
      :user,
      :created_at,
      :updated_at,
    ]
    
    config.actions << :mark
    # config.actions << :batch_base
    # config.actions << :batch_update
    # config.actions << :batch_destroy
    config.actions << :export
    
    config.update.columns = columns = [
      :dst,
      :territory,
      :user,
      :created_at,
      :updated_at,
    ]

    config.columns[:user].clear_link

  end

#  def self.active_scaffold_controller_for(klass)
#    return Admin::RoutesController if klass == Route
#    return Admin::RoutesTerritoryController if klass == Territory
#    return Admin::RoutesUsersController if klass == User
#    return "#{klass}ScaffoldController".constantize rescue super
#  end

end
