# 
# Feature: Chargify Metered Component Usage JSON API
#   In order integrate my app with Chargify
#   As a developer
#   I want to record metered usage for a subscription
# 
#   Background:
#     Given I am a valid API user
#     And I send and accept json
# 
#   Scenario: Record metered usage
#     Given I have 1 product
#     And the product family has a metered component
#     And I have an active subscription to the first product
#     And I have this json usage data
#       """
#       {
#         "usage":{
#           "quantity":5,
#           "memo":"My memo"
#         }
#       }
#       """
#     When I send a POST request with the json data to https://[@subdomain].chargify.com/subscriptions/[@subscription.id]/components/[@component.id]/usages.json
#     Then the response status should be "200 OK"
#     And the response should be the json:
#       """
#       {
#         "usage":{
#           "id":@auto generated@,
#           "quantity":5,
#           "memo":"My memo"
#         }
#       }
#       """
#     And a usage will have been recorded
#
#


User.where("subscription_id IS NOT NULL").find_in_batches do |users|
  users.each do |user|
    metered = {}
    user.calls.where("billed = 'no'").each do |call|
      # hacked pricing
      if call.billsec < 300
        quanity = 5
      else
        quanity = 5 + ((call.billsec - 300) / 60).ceil
      end
      metered << {
        :call => call
        :quantity => quantity,
        :memo => "Received call from #{call.src} @ #{call.billsec} seconds. Total: #{"%.2f" % (quanity*0.1)}"
      }
    end
    if metered.length > 0
      # post
      # if response.success?
      #   metered.each do |resource|
      #     resource.call.update_attribute(:billed, true)
      #   end
      # end
      # get simon to alter table
    end
  end
end

#  if > 0
#    
#  POST  https://<subdomain>.chargify.com/subscriptions/<subscription_id>/components/<component_id>/usages.json
#      {
#        "usage":{
#          "quantity":5,
#          "memo":"My memo"
#        }
#      }
#
#
#