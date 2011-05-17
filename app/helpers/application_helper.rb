# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def page_title(title)
    "<h1 class='page-title'>#{title}</h1>"
  end


  # Block method that creates an area of the view that
  # is only rendered if the request is coming from an
  # anonymous user.
  def anonymous_only(&block)
    if !logged_in?
      block.call
    end
  end

  # Block method that creates an area of the view that
  # only renders if the request is coming from an
  # authenticated user.
  def authenticated_only(&block)
    if logged_in?
      block.call
    end
  end

  # Block method that creates an area of the view that
  # only renders if the request is coming from an
  # administrative user.
  def admin_only(&block)
    role_only("admin", &block)
  end

  def state_options
    I18n.t('states').collect{|abbrev, full_name| [full_name.to_s, abbrev.to_s]}.sort{|a,b| a.first <=> b.first}
  end
  
  def province_options
    I18n.t('provinces').collect{|abbrev, full_name| [full_name.to_s, abbrev.to_s]}.sort{|a,b| a.first <=> b.first}
  end

  def state_options_with_blank(label = "")
    state_options.unshift([label, ""])
  end

  def province_options_with_blank(label = "")
    province_options.unshift([label, ""])
  end
  
  def north_american_options
    [["- #{I18n.t('label.provinces')} -", '']].concat(province_options).concat([["- #{I18n.t('label.states')} -", '']]).concat(state_options)
  end
  
  def north_american_options_with_blank(label = "")
    north_american_options.unshift([label, ""])
  end
  
  def smart_truncate(s, opts = {})
    opts = {:words => 12}.merge(opts)
    if opts[:sentences]
      return s.split(/\./)[0, opts[:sentences]].map{|s| s.strip}.join('. ') + '.'
    end
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    n = opts[:words]
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end


  def subscription_id_column(record)
    if record.subscription  && !record.subscription.blank?
      "<a href='https://d-l-adams-and-associates-inc.chargify.com/subscriptions/#{record.subscription_id}'>@Chargify</a>".html_safe
    else
      ""
    end
  end

  def user_column(record)
    if record && record.user
      link_to record.user.to_s, edit_admin_user_path(
        :id => record.user[:id], 
        :assoc_id => record[:id], 
        :association => 'user', 
        :eid => "admin__calls_#{record[:id]}_user", 
        :parent_scaffold => 'admin/calls',
        :adapter => '_list_inline_adapter'
      ), 
      :remote => true, 
      'data-position'.to_sym => 'after',
      :class => 'edit as_action user',
      :id => "as_admin__calls-edit-user-#{record.user[:id]}-link"
    else
      "-"
    end
  end

  # def subscription_next_assessment_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.next_assessment_at
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_trial_started_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.trial_started_at
  # else
  #     ""
  #   end
  # end
  # 
  # def subscription_trial_ended_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.trial_ended_at
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_activated_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.activated_at
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_created_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.created_at
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_updated_at_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.updated_at
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_cancellation_message_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.cancellation_message
  #   else
  #     ""
  #   end
  # end
  # 
  # def subscription_signup_revenue_column(record)
  #   if record.subscription && !record.subscription.blank?
  #     record.subscription.signup_revenue
  #   else
  #     ""
  #   end
  # end

private

  def admin_user?
    not current_user.blank? and current_user.has_role?("admin")
  end

  def role_only(rolename, &block)
    if admin_user?
      block.call
    end
  end

end

