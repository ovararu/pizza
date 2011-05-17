class Admin::CallsController < ApplicationController
  before_filter :authenticate_admin!

  layout 'admin'

  active_scaffold :call do |config|

    config.columns        = [
      :marked, 
      :calldate,
      :clid,
      :src,
      :dst,
      :duration,
      :billsec,
      :disposition,
      :userfield,
      :user # maps from #accountcode
    ]

    config.columns[:user].clear_link

    config.actions << :config_list

    config.config_list.default_columns = [
      :marked, 
      :calldate,
      :clid,
      :src,
      :dst,
      :duration,
      :billsec,
      :disposition,
      :userfield,
      :user
    ]

    config.actions << :mark
    config.actions << :export

    config.actions.exclude :create
    config.actions.exclude :update
    config.actions.exclude :delete

    config.columns[:user].form_ui = :record_select

    config.actions.swap :search, :field_search
    config.field_search.human_conditions = true

    config.field_search.columns = [
      :calldate,
      :clid,
      :src,
      :dst,
      :duration,
      :billsec,
      :disposition,
      :userfield,
      :user
    ]

    config.list.per_page = 100

    config.label= "Calls"

  end

end
