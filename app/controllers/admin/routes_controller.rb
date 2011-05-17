class Admin::RoutesController < ApplicationController
  before_filter :authenticate_admin!
  
  layout 'admin'
  
  active_scaffold :route do |config|
    config.columns[:territory].form_ui = :record_select
    
    config.actions << :config_list
    
    config.actions << :mark
    # config.actions << :batch_base
    # config.actions << :batch_update
    # config.actions << :batch_destroy
    config.actions << :export

  end
  
end
