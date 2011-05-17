class Route < ActiveRecord::Base
  belongs_to :user
  belongs_to :territory
 
  validates_presence_of :user
  validates_presence_of :territory
  
  validates_format_of   :dst,
                        :with => %r{^\d{3}-\d{3}-\d{4}$},
                        :message => "must be a valid phone number (123-123-1235, ###-###-####)",
                        :allow_blank => true,
                        :allow_nil => true

  # only one user cn own an territory
  validates_uniqueness_of :territory_id
  
  # if multiple users can own a territory
  # validates_uniqueness_of :territory_id, :scope => [:user_id]

  def to_s
    "Routes: #{self.dst} to #{self.territory.sku}".html_safe
  end
  
  def to_json(options = {})
    super(options.merge(:include => :territory))
  end
    
end