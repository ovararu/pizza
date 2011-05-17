class Call < ActiveRecord::Base
  belongs_to :user, 
             :primary_key => 'id',
             :foreign_key => 'accountcode'

  set_table_name 'cdr'

  validates :calldate, :presence => true

  validates :dst, :presence => true
  validates :src, :presence => true
  
  validates_numericality_of :duration, :greater_than_or_equal_to => 0
  validates_numericality_of :billsec, :greater_than_or_equal_to => 0
  validates_numericality_of :amaflags, :greater_than_or_equal_to => 0

  before_validation :set_defaults

  def to_s
    "#{self.dst} -> #{self.src}"
  end

  def set_defaults
    self.calldate ||= Time.now
    self.duration ||= 0
    self.billsec  ||= 0
    self.amaflags ||= 0
  end
end

