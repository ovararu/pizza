class ProvinceValidator < ActiveModel::EachValidator
  Provinces = I18n.t('provinces').collect{|abbrev, full_name| abbrev.to_s.downcase}.sort{|a,b| a.first <=> b.first}
  def validate_each(record, attribute, value)
    unless Provinces.include?(value)
      record.errors[attribute] << "must be one of #{I18n.t('provinces').collect{|abbrev, full_name| full_name.to_s}.sort{|a,b| a.first <=> b.first}.join(", ")}"
    end
  end
end

class User < ActiveRecord::Base

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :token_authenticatable,
         # :confirmable,
         :lockable,
         :timeoutable

  # Additional properties /_________

  attr_accessor :expiration_month,
                :expiration_year,
                :credit_card_number,
                :cvv

  serialize :roles, Array

  # Mass-assignemnt /_________

  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :first_name, 
                  :last_name,
                  :dst,
                  :province,
                  :expiration_month, 
                  :expiration_year, 
                  :credit_card_number, 
                  :cvv, 
                  :customer_id,
                  :subscription_id, 
                  :remember_me,
                  :business_name,
                  :business_address,
                  :business_city,
                  :business_province,
                  :business_postal_code

  # RELATIONSHIPS /_________

  has_many :routes
  has_many :territories,  :through => :routes, :uniq => true

  has_many :calls, :class_name => 'Call', :primary_key => 'id', :foreign_key => 'accountcode'
  

  # VALIDATIONS /_________

  validates_associated :routes

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  
  # validates_presence_of [:expiration_month, :expiration_year, :credit_card_number, :cvv], :unless => Proc.new { |user| user.admin? || @subscribing.nil? }

  validates_format_of  :dst,
                       :with => %r{^\d{3}-\d{3}-\d{4}$},
                       :message => "must be a valid phone number (123-123-1235, ###-###-####)",
                       :unless => Proc.new { |user| user.admin? }

   validates           :province,
                       :province => true,
                       :unless => Proc.new { |user| user.admin? }

   validates           :business_province,
                       :province => true,
                       :unless => Proc.new { |user| user.admin? },
                       :if     => Proc.new { |user| user.business_province && !user.business_province.empty? }


  before_validation :ensure_roles_is_array
  before_validation :fix_blank_passwords_for_activescaffold


  # subscribe /_________

  def subscribe(product_id)
    @subscribing = true
    
    return unless self.valid?
    User.transaction do
      self.save
      subscription = Chargify::Subscription.new(subscription_params(product_id))
      if subscription.save
        self.update_attributes!(:customer_id => subscription.customer.id, :subscription_id => subscription.id)
      else
        subscription.errors.full_messages.each{|err| errors.add_to_base(err)}
        false
        raise ActiveRecord::Rollback 
      end
    end
  end


  def subscription_next_assessment_at
    if self.subscription && !self.subscription.blank?
      self.subscription.next_assessment_at
    else
      nil
    end
  end

  def subscription_trial_started_at
    if self.subscription && !self.subscription.blank?
      self.subscription.trial_started_at
  else
      nil
    end
  end

  def subscription_trial_ended_at
    if self.subscription && !self.subscription.blank?
      self.subscription.trial_ended_at
    else
      nil
    end
  end

  def subscription_activated_at
    if self.subscription && !self.subscription.blank?
      self.subscription.activated_at
    else
      nil
    end
  end

  def subscription_created_at
    if self.subscription && !self.subscription.blank?
      self.subscription.created_at
    else
      nil
    end
  end

  def subscription_updated_at
    if self.subscription && !self.subscription.blank?
      self.subscription.updated_at
    else
      nil
    end
  end

  def subscription_cancellation_message
    if self.subscription && !self.subscription.blank?
      self.subscription.cancellation_message
    else
      nil
    end
  end

  def subscription_signup_revenue
    if self.subscription && !self.subscription.blank?
      self.subscription.signup_revenue
    else
      nil
    end
  end





  # RESTFUL LIMITS /_________

  # Limit to_xml/to_json with the basics
  TO_JSON_BASE_OPTIONS = {
    :only => [:email, :first_name, :last_name, :active],
    :methods => []
  }
  TO_XML_BASE_OPTIONS = TO_JSON_BASE_OPTIONS.merge({
    :skip_types => true
    # , :skip_nils => true
    # see https://rails.lighthouseapp.com/projects/8994/tickets/1480-xmlserializer-with-option-skip_nils
  })
  def to_s
    "#{self.fullname} [ID:#{self.id}]"
  end
  def to_json(options = {})
    super(TO_JSON_BASE_OPTIONS.merge(options))
  end
  def to_xml(options = {})
    super(TO_XML_BASE_OPTIONS.merge(options))
  end

  # VIRTUAL /________

  def fullname
    (read_attribute(:first_name) + ' ' + read_attribute(:last_name)).titleize
  end

  # lag help
  extend ActiveSupport::Memoizable

  def subscription
    Chargify::Subscription.find(subscription_id)
  rescue ActiveResource::ResourceNotFound
    ""
  end

  def customer
    Chargify::Customer.find(customer_id)
  end
  
  # must call after def
  memoize :subscription, :customer

  # FLAG! /_________

  def activate!
    update_attribute(:active, true)
  end

  # MAIL /_________

  # after_create :deliver_welcome!

  # invoked via /account/activation/:activation_code -> success -> redirect?
  # def deliver_welcome!
  #  # reset_perishable_token!
  #   Notifier.deliver_welcome(self)
  # end

  # ROLES /_________

  def admin?
    has_role?("admin")
  end

  def has_role?(role)
    roles.include?(role) unless roles.nil?
  end

  def add_role(role)
    self.roles << role
  end

  def remove_role(role)
    self.roles.delete(role)
  end

  def clear_roles
    self.roles = []
  end

  private
  
    # enfore a blank array over nil
    def ensure_roles_is_array
      clear_roles if roles.nil?
    end
    
    def fix_blank_passwords_for_activescaffold
      self.password = nil if self.password.blank?
      self.password_confirmation = nil if self.password_confirmation.blank?
    end

    def customer_params
      {
        :first_name   => first_name,
        :last_name    => last_name,
        :email        => email,
        :reference    => id,
        :organization => "",
      }
    end

    def subscription_params(product_id)
      {
        :product_id => product_id,
        :customer_attributes => customer_params,
        :credit_card_attributes => {
          :full_number => credit_card_number,
          :cvv => cvv,
          :expiration_month => expiration_month,
          :expiration_year => expiration_year
        }
      }
    end

end

