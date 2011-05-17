class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  
  layout 'admin'
  
  record_select :per_page  => 10, :search_on => [:email, :first_name, :last_name, :dst], :order_by => 'email, first_name, last_name'
  
  active_scaffold :user do |config|

    config.columns        = [
      :marked, 
      :first_name,
      :last_name,
      :email,
      :roles,
      :calls,
      :routes,
      :territories,
      :subscription_id,
      :subscription_next_assessment_at,
      #:subscription_trial_started_at,
      :subscription_trial_ended_at,
      :subscription_activated_at,
      #:subscription_created_at,
      :subscription_updated_at,
      :subscription_cancellation_message,
      :subscription_signup_revenue,
      :sign_in_count,
      :failed_attempts,
      #:active,
      #:api_key,
      #:api_secret,
      #:remember_created_at,
      #:confirmation_sent_at,
      :confirmed_at,
      :last_sign_in_ip,
      :current_sign_in_ip,
      :last_sign_in_at,
      :current_sign_in_at,
      :locked_at,
      :updated_at,
      :created_at,
      # :password,
      # :password_confirmation,
      # :encrypted_password,
      # :password_salt,
      # :authentication_token,
      # :confirmation_token,
      # :remember_token,
      # :reset_password_token,
      # :unlock_token
    ]
    
    config.actions << :config_list
    
    config.config_list.default_columns = [
      :marked, 
      :first_name,
      :last_name,
      :email,
      :roles,
      :calls,
      :routes,
      :territories,
      :subscription_id,
      :subscription_next_assessment_at,
      :subscription_trial_started_at,
      :subscription_trial_ended_at,
      :subscription_activated_at,
      :subscription_created_at,
      :subscription_updated_at,
      :subscription_cancellation_message,
      :subscription_signup_revenue,
      :sign_in_count,
      :failed_attempts,
      # :active,
      # :api_key,
      # :api_secret,
      :remember_created_at,
      :confirmation_sent_at,
      :confirmed_at,
      :last_sign_in_ip,
      :current_sign_in_ip,
      :last_sign_in_at,
      :current_sign_in_at,
      :locked_at,
      :updated_at,
      :created_at,
      # :password,
      # :password_confirmation,
      # :encrypted_password,
      # :password_salt,
      :authentication_token,
      :confirmation_token,
      :remember_token,
      :reset_password_token,
      :unlock_token
    ]
    
    config.actions << :mark
    # config.actions << :batch_base
    # config.actions << :batch_update
    # config.actions << :batch_destroy
    config.actions << :export
    
    # light weight
    config.create.columns = [
      :first_name,
      :last_name,
      :dst,
      :email,
      :password,
      :password_confirmation,
    ]
    config.update.columns = [
      :first_name,
      :last_name,
      :dst,
      :email,
      :active,
      :remember_created_at,
      :confirmation_sent_at,
      :confirmed_at,
      :locked_at,
      # :failed_attempts,
      # :remember,
      # :api_key,
      # :api_secret,
      # :last_sign_in_at,
      # :last_sign_in_ip,
      # :current_sign_in_at,
      # :current_sign_in_ip,
      # :updated_at,
      # :created_at,
      # :roles
      # :password,
      # :password_confirmation,
      # :encrypted_password,
      # :password_salt,
      # :authentication_token,
      # :confirmation_token,
      # :remember_token,
      # :reset_password_token,
      # :unlock_token
    ]
    
    config.subform.columns.exclude :active
    config.subform.columns.exclude :remember_created_at
    config.subform.columns.exclude :confirmation_sent_at
    config.subform.columns.exclude :confirmed_at
    config.subform.columns.exclude :locked_at
    
    config.subform.columns << :password
    config.subform.columns << :password_confirmation
    
    config.list.per_page = 5
    
  end
  
  
  # def conditions_for_collection
  #   '"campaigns"."session_id" IS NULL'
  # end
  
end
