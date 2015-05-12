require 'rubygems'
require 'mechanize'

@taxations = {
  :ab => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :bc => {
    :hst => 0.12,
    :gst => 0.00,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :mb => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.07,
    :gst_on_pst => false
  },
  :nb => {
    :hst => 0.13,
    :gst => 0.00,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :nl => {
    :hst => 0.13,
    :gst => 0.00,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :ns => {
    :hst => 0.15,
    :gst => 0.00,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :on => {
    :hst => 0.13,
    :gst => 0.00,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :pe => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.10,
    :gst_on_pst => true
  },
  :qc => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.085,
    :gst_on_pst => true
  },
  :sk => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.05,
    :gst_on_pst => false
  },
  :nt => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :yt => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.00,
    :gst_on_pst => false
  },
  :nu => {
    :hst => 0.00,
    :gst => 0.05,
    :pst => 0.00,
    :gst_on_pst => false
  }
}

@provinces = I18n.t('provinces').inject({}) do |result, element| 
  result[element.first.to_s.downcase.to_sym] = element.last
  result
end


# honestly, 
# * why don't you have an API for creation?
# * why don't you support taxes?

a = Mechanize.new
a.get('https://app.chargify.com/login') do |page|

  index_page = page.form_with(:action => '/session') do |form|
    form['session[login]']    = 'dladams'
    form['session[password]'] = '123456789'
  end.click_button

  a.get('https://app.chargify.com/sites/5348-d-l-adams-and-associates-inc/clear_data') do |clear_page|
    clear_page.form_with(:action => "https://app.chargify.com/sites/5348-d-l-adams-and-associates-inc/clear_data") do |form|
    end.click_button
  end

  dashboard_page = index_page.link_with(:href => "https://d-l-adams-and-associates-inc.chargify.com/dashboard").click
  products_page  = dashboard_page.link_with(:href => /\/products/).click

  @taxations.each do |province, taxation|
    new_product_family_page  = dashboard_page.link_with(:href => /\/product_families\/new/).click
    puts "Create product family for: #{@provinces[province]}"

    new_product_family_page.form_with(:action => '/product_families') do |form|
      form['product_family[name]']        = @provinces[province]
      form['product_family[description]'] = "Tax included products for #{@provinces[province]}"
      form['product_family[handle]']      = province.to_s
    end.click_button
  end

  # refresh
  products_page  = dashboard_page.link_with(:href => /\/products/).click

  products_page.links_with(:text => /Create the First Product/) do |province_links|
    province_links.each do |province_link|
      new_product_page  = province_link.click
      which_province    = new_product_page.search("/html/body/div[5]/div/div/p").text.gsub(/Use the form below to create a new /, "").gsub(/ product. Fields marked \* are required\./, "")
        #                                                   /html/body/div[6]/div/div/p
      which_province    = @provinces.invert[which_province]

      taxation = @taxations[which_province]

      new_product_page.form_with(:action => /\/product_families\/[0-9]{5}\/products/) do |form|
        puts "Create product '#{@provinces[which_province]} Subscription'"
        form['product[name]']                     = "#{@provinces[which_province]} Subscription"
        form['product[description]']              = "No down payment!\n\nTry free for the first 14 days. (Minutes and routed calls charged separately.)"
        form['product[accounting_code]']          = "standard"
        form['product[return_url]']               = "http://pizza-router.heroku.com/thanks"
        form['product[return_params]']            = 'subscription_id={subscription_id}&customer_reference={customer_reference}'
        form['product[handle]']                   = "standard_#{which_province}"
        form['product[initial_charge]']           = '0.00'
        form['product[trial_interval]']           = '14'
        form['product[trial_interval_unit]']      = 'day'
        form['product[trial_price]']              = '0.00'
        form['product[price]']                    = '0.00'
        form['product[interval]']                 = '1'
        form['product[interval_unit]']            = 'month'
        form['product[expiration_interval]']      = ''
        form['product[expiration_interval_unit]'] = 'never'
      end.click_button

    end
  end

  products_page.links_with(:text => /Create a Component/) do |component_links|
    component_links.each do |components_link|
      components_page    = components_link.click
      
      # create 'minutes' unit
      new_component_page = components_page.link_with(:text => /Create a Metered component/).click

      which_province    = new_component_page.search("/html/body/div[5]/div/div/div/div[2]/p").text.gsub(/Use the form below to create a new /, "").gsub(/ component\. Fields marked \* are required\./, "")
      which_province    = @provinces.invert[which_province]

      taxation = @taxations[which_province]

      new_component_page.form_with(:action => /\/product_families\/[0-9]{5}\/metered_components/) do |form|
        puts "Create minutes component '#{@provinces[which_province]}'"
        form['metered_component[name]']           = "Minutes"
        form['metered_component[unit_name]']      = "minute"
        form['metered_component[pricing_scheme]'] = "per_unit"

        unit_price = 0.1
        if taxation[:gst_on_pst]
          form['metered_component[unit_price]']     = "%.4f" % ( unit_price * ( 1 + ( taxation[:gst] * taxation[:pst] + (taxation[:gst] + taxation[:pst]) ) ) )
        else
          form['metered_component[unit_price]']     = "%.4f" % ( unit_price * ( 1 + ( taxation[:hst] + taxation[:pst] + taxation[:gst] ) ) )
        end
      end.click_button


      # create 'territory' price tier
      new_component_page = components_page.link_with(:text => /Create a Quantity based component/).click

      which_province    = new_component_page.search("/html/body/div[5]/div/div/div/div[2]/p").text.gsub(/Use the form below to create a new /, "").gsub(/ component\. Fields marked \* are required\./, "")
      which_province    = @provinces.invert[which_province]

      taxation = @taxations[which_province]

      new_component_page.form_with(:action => /\/product_families\/[0-9]{5}\/quantity_based_components/) do |form|
        puts "Create territory component '#{@provinces[which_province]}'"
        form['quantity_based_component[name]']           = "Territories"
        form['quantity_based_component[unit_name]']      = "territory"
        form['quantity_based_component[pricing_scheme]'] = "tiered"

        if taxation[:gst_on_pst]
          form['quantity_based_component[prices_attributes][0][starting_quantity]'] = "1"
          form['quantity_based_component[prices_attributes][0][ending_quantity]']   = "2"
          form['quantity_based_component[prices_attributes][0][unit_price]']        = "%.4f" % ( 39.95 * ( 1 + ( taxation[:gst] * taxation[:pst] + (taxation[:gst] + taxation[:pst]) ) ) )
          form['quantity_based_component[prices_attributes][1][starting_quantity]'] = "3"
          form['quantity_based_component[prices_attributes][1][ending_quantity]']   = "3"
          form['quantity_based_component[prices_attributes][1][unit_price]']        = "%.4f" % ( 33.00 * ( 1 + ( taxation[:gst] * taxation[:pst] + (taxation[:gst] + taxation[:pst]) ) ) )
          form['quantity_based_component[prices_attributes][2][starting_quantity]'] = "4"
          form['quantity_based_component[prices_attributes][2][ending_quantity]']   = ""
          form['quantity_based_component[prices_attributes][2][unit_price]']        = "%.4f" % ( 29.95 * ( 1 + ( taxation[:gst] * taxation[:pst] + (taxation[:gst] + taxation[:pst]) ) ) )
        else
          form['quantity_based_component[prices_attributes][0][starting_quantity]'] = "1"
          form['quantity_based_component[prices_attributes][0][ending_quantity]']   = "2"
          form['quantity_based_component[prices_attributes][0][unit_price]']        = "%.4f" % ( 39.95 * ( 1 + ( taxation[:hst] + taxation[:pst] + taxation[:gst] ) ) )
          form['quantity_based_component[prices_attributes][1][starting_quantity]'] = "3"
          form['quantity_based_component[prices_attributes][1][ending_quantity]']   = "3"
          form['quantity_based_component[prices_attributes][1][unit_price]']        = "%.4f" % ( 33.00 * ( 1 + ( taxation[:hst] + taxation[:pst] + taxation[:gst] ) ) )
          form['quantity_based_component[prices_attributes][2][starting_quantity]'] = "4"
          form['quantity_based_component[prices_attributes][2][ending_quantity]']   = ""
          form['quantity_based_component[prices_attributes][2][unit_price]']        = "%.4f" % ( 29.95 * ( 1 + ( taxation[:hst] + taxation[:pst] + taxation[:gst] ) ) )
        end
      end.click_button

    end
  end

end
