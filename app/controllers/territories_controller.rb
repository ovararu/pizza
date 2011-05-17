class TerritoriesController < InheritedResources::Base
  include Cartographer
  
  defaults :resource_class => Territory, :collection_name => 'territories', :instance_name => 'territory'
 
  respond_to :html, :only => [:index, :show]
  respond_to :json, :only => [:index]
  
  actions :index, :show

  before_filter :authenticate_user!
  
  # derp caches_action :index
  
  def show
    @territory = resource
    
    unless request.xhr?
      redirect_to territories_path and return true
    else
      render :layout => false
    end
  end

  protected
    
    def collection
      @territories || set_collection_ivar(Rails.cache.read("territories") || Territory.all)

      @map = initialize_map()
      @map.zoom = :bound

      @icon_territory_off = Cartographer::Gicon.new(
        :name => "territory_off",
        :image_url => '/images/territory_off.gif',
        :shadow_url => '/images/territory_off.gif',
        :width => 32,
        :height => 23,
        :shadow_width => 32,
        :shadow_height => 23,
        :anchor_x => 0,
        :anchor_y => 20,
        :info_anchor_x => 5,
        :info_anchor_x => 1
      )

      @icon_territory_on = Cartographer::Gicon.new(
        :name => "territory_on",
        :image_url => '/images/territory_on.gif',
        :shadow_url => '/images/territory_on.gif',
        :width => 32,
        :height => 23,
        :shadow_width => 32,
        :shadow_height => 23,
        :anchor_x => 0,
        :anchor_y => 20,
        :info_anchor_x => 5,
        :info_anchor_x => 1
      )

      # Add the icons to map
      @map.icons <<  @icon_territory_off
      @map.icons <<  @icon_territory_on

      @territories.each do |territory|
        has_matching_route = (!current_user.routes.nil? && current_user.routes.any? {|route| route.territory == territory})
        @map.markers <<  Cartographer::Gmarker.new(
          :icon            =>  has_matching_route ? @icon_territory_on : @icon_territory_off,
          :marker_type     => "Territories",
          :name            => "territory_#{territory.sku}", 
          :position        => [territory.latitude, territory.longitude],
          :title           => territory.title, 
          :info_window_url => "/territories/#{territory.id}?has_matching_route=#{has_matching_route}",
          :dblclick        => "App.toggleTerritory(territory_#{territory.sku}, #{territory.id}, #{has_matching_route});"
        )
      end
      
      Rails.cache.write("territories", @territories)
    end

private

  def initialize_map
    @map = Cartographer::Gmap.new( 'map' )
    @map.controls << :type
    @map.controls << :large
    @map.controls << :scale
    @map.controls << :overview
    @map.debug = true 
    @map.marker_mgr = false
    @map.marker_clusterer = true
    @map.type = :terrain

    cluster_icons = []

    org = Cartographer::ClusterIcon.new({:marker_type => "Territories"})

    cluster_icons << org

    @map.marker_clusterer_icons = cluster_icons

    return @map
  end

end
