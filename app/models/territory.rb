class Territory < ActiveRecord::Base
  has_many :routes
  has_many :users, :through => :routes, :uniq => true

  validates_presence_of :body, :tally

  def to_s
    "#{self.sku} [TID:#{self.id}]"
  end
  
  # assist tiny_mce
  def body
    read_attribute(:body).html_safe
  end

end