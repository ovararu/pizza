module WillPaginateHelper
  # Y U NO NEED DEF
  def to_xml(options = {})
    super(options) # -> ActiveSupport -> core_ext -> to_xml
  end
  
  def to_xml_with_collection_type(options = {})
    serializeable_collection.to_xml_without_collection_type(options) do |xml|
      xml.tag!(:current_page, {:type => "integer"}, current_page)
      xml.tag!(:per_page, {:type => "integer"}, per_page)
      xml.tag!(:total_entries, {:type => "integer"}, total_entries)
    end.sub(%{type="array"}, %{type="collection"})
  end
  alias_method_chain :to_xml, :collection_type

  def serializeable_collection #:nodoc:
    # Ugly hack because to_xml will not yield the XML Builder object when empty?
    empty? ? returning(self.clone) { |c| c.instance_eval {|i| def empty?; false; end } } : self
  end
end
WillPaginate::Collection.send(:include, WillPaginateHelper)

# Cleaner controllers.
module InheritedResources
  # = Base
  #
  # This is the base class that holds all actions. If you see the code for each
  # action, they are quite similar to Rails default scaffold.
  #
  # To change your base behavior, you can overwrite your actions and call super,
  # call <tt>default</tt> class method, call <<tt>actions</tt> class method
  # or overwrite some helpers in the base_helpers.rb file.
  #
  class Base < ::ApplicationController
    # Overwrite inherit_resources to add specific InheritedResources behavior.
    def self.inherit_resources(base)
      base.class_eval do
        include InheritedResources::Actions
        include InheritedResources::BaseHelpers
        
        # EDIT: DIGEST THE DSL, Yummy!
        include InheritedResources::DSL
        
        extend  InheritedResources::ClassMethods
        extend  InheritedResources::UrlHelpers

        # Add at least :html mime type
        respond_to :html
        self.responder = InheritedResources::Responder

        helper_method :collection_url, :collection_path, :resource_url, :resource_path,
                      :new_resource_url, :new_resource_path, :edit_resource_url, :edit_resource_path,
                      :parent_url, :parent_path, :resource, :collection, :resource_class, :association_chain,
                      :resource_instance_name, :resource_collection_name

        base.with_options :instance_writer => false do |c|
          c.class_inheritable_accessor :resource_class
          c.class_inheritable_array :parents_symbols
          c.class_inheritable_hash :resources_configuration
        end

        protected :resource_class, :parents_symbols, :resources_configuration
      end
    end

    inherit_resources(self)
  end
end


module InheritedResources
  # Base helpers for InheritedResource work. Some methods here can be overwriten
  # and you will need to do that to customize your controllers from time to time.
  #
  module BaseHelpers

    protected
      def collection
        pagination ||= {}
      
        pagination[:page]     ||= (params[:page] || 1)
        pagination[:per_page] ||= (params[:per_page] || 15) # matches activescaffold defaults otherwise; keep in sync if changing... 
        
        # TODO: something safe
        # pagination[:order]    ||= 'sessions.created_at DESC'

        get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(pagination))
      end
    
  end
end


