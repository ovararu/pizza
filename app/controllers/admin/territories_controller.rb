class Admin::TerritoriesController < ApplicationController
  before_filter :authenticate_admin!
  
  layout 'admin'
  
  record_select :per_page  => 10, :search_on => [:sku], :order_by => 'sku'
  
  uses_tiny_mce
  
  active_scaffold :territory do |config|
    
    config.columns        = columns = [
      :sku,
      :title,
      :tally,
      :routes,
      :users,
      :created_at,
      :updated_at,
    ]

    config.actions << :config_list
    
    config.config_list.default_columns = [
      :sku,
      :title,
      :tally,
      :routes,
      :users,
      :created_at,
      :updated_at,
    ]

    config.actions << :mark
    config.actions << :export

    config.actions.exclude :create
    
    # NO CREATE FOR U
    #
    # config.create.columns = columns = [
    #   :sku,
    #   :title,
    #   :body,
    #   :tally,
    #   :latitude,
    #   :longitude,
    #   :routes,
    #   :users,
    #   :created_at,
    #   :updated_at,
    # ]

    # config.actions.exclude :update

    config.update.columns = columns = [
      :sku,
      :title,
      :body,
      :tally,
      # :latitude, # Can edit hard floats...
      # :longitude,
      :routes,
      :users,
      :created_at,
      :updated_at,
    ]

    config.columns[:body].form_ui = :text_editor
  end

  def self.active_scaffold_controller_for(klass)
    return Admin::TerritoriesController if klass == Territory
    return Admin::TerritoriesRoutesController if klass == Route
    #return Admin::TerritoriesUsersController if klass == User
    return "#{klass}ScaffoldController".constantize rescue super
  end

end

