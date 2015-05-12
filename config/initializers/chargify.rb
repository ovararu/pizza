if Rails.env.development?
  Chargify.configure do |c|
    c.subdomain = "pizza-router"
    c.api_key   = 'rARJhBk1sC_9UW0nUPRt'
  end
  
  $SHARED_SITE_ID = 'vQhWvKvQeEOwuLJnKbGu'
  
  $TAXATION = {
    :ab => {
      :product_id             => 38886,
      :minute_component_id    => 4542,
      :territory_component_id => 4543
    },
    :bc => {
      :product_id             => 38887,
      :minute_component_id    => 4544,
      :territory_component_id => 4545
    },
    :mb => {
      :product_id             => 38888,
      :minute_component_id    => 4546,
      :territory_component_id => 4547
    },
    :nb => {
      :product_id             => 38889,
      :minute_component_id    => 4548,
      :territory_component_id => 4549
    },
    :nl => {
      :product_id             => 38890,
      :minute_component_id    => 4550,
      :territory_component_id => 4551
    },
    :nt => {
      :product_id             => 38891,
      :minute_component_id    => 4552,
      :territory_component_id => 4553
    },
    :ns => {
      :product_id             => 38892,
      :minute_component_id    => 4554,
      :territory_component_id => 4555
    },
    :nu => {
      :product_id             => 38893,
      :minute_component_id    => 4556,
      :territory_component_id => 4557
    },
    :on => {
      :product_id             => 38894,
      :minute_component_id    => 4558,
      :territory_component_id => 4559
    },
    :pe => {
      :product_id             => 38895,
      :minute_component_id    => 4560,
      :territory_component_id => 4561
    },
    :qc => {
      :product_id             => 38896,
      :minute_component_id    => 4562,
      :territory_component_id => 4563
    },
    :sk => {
      :product_id             => 38897,
      :minute_component_id    => 4564,
      :territory_component_id => 4565
    },
    :yt => {
      :product_id             => 38898,
      :minute_component_id    => 4566,
      :territory_component_id => 4567
    }
  }
  
else
  Chargify.configure do |c|
    c.subdomain = "d-l-adams-and-associates-inc"
    c.api_key   = 'n73kVrxJGv67Icp9z1u4'
  end

  $SHARED_SITE_ID = 'zGcKupZZV7XviGEr7PhV'

  $TAXATION = {
    :ab => {
      :product_id             => 40209,
      :minute_component_id    => 4668,
      :territory_component_id => 4669
    },
    :bc => {
      :product_id             => 40210,
      :minute_component_id    => 4670,
      :territory_component_id => 4671
    },
    :mb => {
      :product_id             => 40211,
      :minute_component_id    => 4672,
      :territory_component_id => 4673
    },
    :nb => {
      :product_id             => 40212,
      :minute_component_id    => 4674,
      :territory_component_id => 4675
    },
    :nl => {
      :product_id             => 40213,
      :minute_component_id    => 4676,
      :territory_component_id => 4677
    },
    :nt => {
      :product_id             => 40214,
      :minute_component_id    => 4678,
      :territory_component_id => 4679
    },
    :ns => {
      :product_id             => 40215,
      :minute_component_id    => 4680,
      :territory_component_id => 4681
    },
    :nu => {
      :product_id             => 40216,
      :minute_component_id    => 4682,
      :territory_component_id => 4683
    },
    :on => {
      :product_id             => 40217,
      :minute_component_id    => 4684,
      :territory_component_id => 4685
    },
    :pe => {
      :product_id             => 40218,
      :minute_component_id    => 4686,
      :territory_component_id => 4687
    },
    :qc => {
      :product_id             => 40219,
      :minute_component_id    => 4688,
      :territory_component_id => 4689
    },
    :sk => {
      :product_id             => 40220,
      :minute_component_id    => 4690,
      :territory_component_id => 4691
    },
    :yt => {
      :product_id             => 40221,
      :minute_component_id    => 4692,
      :territory_component_id => 4693
    }
  }
end




