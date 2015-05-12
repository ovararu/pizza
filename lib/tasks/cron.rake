require 'net/http'
require 'net/https'
require 'json'

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour == 0 # run at midnight
    User.where("subscription_id IS NOT NULL").find_in_batches do |users|
      users.each do |user|
        metered = []
        user.calls.where("billed = 'no'").each do |call|

          if call.billsec < 300
            quantity = 5
          else
            quantity = 5 + ((call.billsec - 300) / 60).ceil
          end
          metered << {
            :call => call,
            :quantity => quantity,
            :memo => "Received call from #{call.src} to #{call.dst} for #{call.billsec} seconds."
          }

        end

        # for every minute call push a usage charge :(
        if metered.length > 0
          request = Net::HTTP::Post.new("/subscriptions/#{user.subscription_id}/components/#{$TAXATION[user.province.to_sym][:minute_component_id]}/usages.json", {'Content-Type' =>'application/json'})
          request.basic_auth Chargify.api_key, "x"

          metered.each do |resource|
            request.body = {
              :usage => {
                :quantity => resource[:quantity],
                :memo     => resource[:memo]
              }
            }.to_json

            http = Net::HTTP.new("#{Chargify.subdomain}.chargify.com", 443)
            http.use_ssl = true
            response = http.request(request)

            if response.is_a? Net::HTTPOK # check body generated an id
              resource[:call].update_attribute(:billed, true)
            else
              Rails.logger.warn "Unable to create call usage #{user.inspect}"
            end
          end
        end

        # create/update terrritories
        component = Chargify::Subscription::Component.find($TAXATION[user.province.to_sym][:territory_component_id], :params => {:subscription_id => user.subscription_id})
        component.allocated_quantity = user.routes.size
        component.save

      end
    end
  end
end