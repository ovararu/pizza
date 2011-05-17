// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});


//document.location = request.getResponseHeader('location')


App = {
  init : function(){
    $("#tabs").tabs({
        select: function(event, ui) {
          if( ui.index == 1){
            var url = $.data(ui.tab, 'load.tabs');
            if( url ) {
                location.href = url;
                return false;
            }
          }
          return true;
        }
    });
    
    //ui hack for google
    $('#tabs').bind('tabsshow', function(event, ui) {
        if (ui.panel.id == "edit-your-regions") {
          google.maps.event.trigger(map, 'resize'); 
        }
    });
    
    $('#route_dst').mask('999-999-9999');

    //welcome page
    $('.slideshow').cycle({
      fx: 'scrollHorz'
    });
    
    if(App.debugMode()){
      $("body").addGrid(12);
    }
  },
  debugMode : function(){
    var host = window.location.host;
    return host.match(/localhost/)
  },
  getOrders : function(e){
    $.ajax({
       type: "GET",
       url : this.href,
       data: {}, 
       complete : function(response){
          if(response.responseText != "")
            $('#ui-tabs-1').html(response.responseText);
       }
     });
     e.preventDefault();
  },
  refreshReview : function(){
    $.ajax({
       type: "GET",
       url : App.order_url() + "/review",
       data: {}, 
       complete : function(response){
          if(response.responseText != "")
            $('.review').html(response.responseText);
       }
     });
  },
  addRoute : function(territory_id){
    $.ajax({
      type: "POST",
      url : "/routes.json",
      dataType: 'json',
      data: {
       'route[territory_id]': territory_id
      }, 
      //         data: { page : JSON.strigify( {...} ) },
      //         dataType: 'json',
      error: function(){
        alert('Sorry we couldn\'t add that territory, please refresh your browser');
      },
      complete : function(xhr){
        route = $.parseJSON(xhr.responseText).route;
        //wiii
        eval('territory_' + route.territory.sku + '.setIcon(new google.maps.MarkerImage("/images/territory_on.gif",google.maps.Size(32,23),google.maps.Point(0,0),google.maps.Point(0,20),google.maps.Size(32,23)));default_shared_info_window.close();');

        html  = '<li class="route_' + route.territory.sku + '">'
        html += '  <div class="route">'
        html += '     <div class="label">'
        html += '       <strong>Territory (FSA):</strong>'
        html += '       <a href="javascript:map.setCenter(new google.maps.LatLng(' + route.territory.latitude + ', ' + route.territory.longitude + '));map.setZoom(12);">' + route.territory.sku + '</a>'
        html += '     </div>'
        html += '     <div class="remove">'
        html += '       ['
        html += '       <a href="javascript:App.removeRoute(' + route.id + ');">X</a>'
        html += '       ]'
        html += '     </div>'
        html += '   </div>'
        html += '   <br>'
        html += '   <strong>House-holds:</strong>'
        html += '   <em>' + route.territory.tally + '</em>'
        html += '   <br>'
        html += '   <strong>Route To:</strong>'
        html += '   <div class="route_' + route.territory.sku + '_dst">' + ((route.dst == null) ? '' : route.dst)  + '</div>'
        html += ' </li>'

        $('#routes').append(html).find('.no-routes').hide();
        
        $('.route_' + route.territory.sku + '_dst').editable('/routes/' + route.id, App.in_place_route_dst_options()); 
        
        
        $('#subscribe-link').show();
       }
    });
  },
  removeRoute : function(route_id){
    $.ajax({
       type: "POST",
       url : "/routes/" + route_id + '.json',
       dataType: 'json',
       data: {
         _method : 'DELETE',
       },
       error: function(){
         alert('Sorry we couldn\'t add that route, please refresh your browser');
       },
       complete : function(xhr){
         route = $.parseJSON(xhr.responseText).route;
         
         //wiii
         eval('territory_' + route.territory.sku + '.setIcon(new google.maps.MarkerImage("/images/territory_off.gif",google.maps.Size(32,23),google.maps.Point(0,0),google.maps.Point(0,20),google.maps.Size(32,23)));default_shared_info_window.close();');
         //jquery template...?
         //hide...
         
         $('#routes').find('.route_' + route.territory.sku).remove();
         if( $('#routes').find('li').length == 0){
           $('#routes .no-routes').show();
           $('#subscribe-link').hide();
         }
         
       }
    });
  },
  /* cheap hack to get the resource url for ajax */
  order_url : function(){
    order_url = window.location.href;
    order_url = order_url.replace("/edit", "");
    order_url = order_url.replace("#review-and-checkout", "");
    return order_url;
  },
  
  //returns options for inplace editor
  in_place_route_dst_options : function(){
    return {
      type      : 'masked',
      mask      : '999-999-9999',
      indicator : '<img src=img/indicator.gif>',
      name      : 'route[dst]',
      tooltip   : 'Click to edit...',
      submitdata: { _method: 'put' },
      submit    : 'OK',
      //  event     : 'dblclick',"
      style     : 'inherit',
      ajaxoptions : {
        success: function(json, a, c){
          route = $.parseJSON(json).route;
          
          container = $('.route_' + route.territory.sku);
          
          html  = '<li class="route_' + route.territory.sku + '">'
          html += '  <div class="route">'
          html += '     <div class="label">'
          html += '       <strong>Territory (FSA):</strong>'
          html += '       <a href="javascript:map.setCenter(new google.maps.LatLng(' + route.territory.latitude + ', ' + route.territory.longitude + '));map.setZoom(12);">' + route.territory.sku + '</a>'
          html += '     </div>'
          html += '     <div class="remove">'
          html += '       ['
          html += '       <a href="javascript:App.removeRoute(' + route.id + ');">X</a>'
          html += '       ]'
          html += '     </div>'
          html += '   </div>'
          html += '   <br>'
          html += '   <strong>House-holds:</strong>'
          html += '   <em>' + route.territory.tally + '</em>'
          html += '   <br>'
          html += '   <strong>Route To:</strong>'
          html += '   <div class="route_' + route.territory.sku + '_dst">' + ((route.dst == null) ? '' : route.dst)  + '</div>'
          html += ' </li>'

          container.replaceWith( html );

          $('.route_' + route.territory.sku + '_dst').editable('/routes/' + route.id, App.in_place_route_dst_options()); 
        }
      },
      onsubmit: function(settings, td) {
        var input = $(td).find('input');
        //allow clearing of numbers
        if(input.val() == "###-###-####"){
          input.val("");
          return true;
        } else if(input.val().match(/^[0-9]{3}-[0-9]{3}-[0-9]{4}$/)){
          return true;
        } else {
          alert('Transfer number must be in the format of ###-###-####');
          input.css('background-color','#e88').css('color','#fff');
          return false;
        }
      }
    }
  }
}

$(document).ready(function() {
  App.init();
});



//lazy fucnctions

function str_replace (search, replace, subject, count) {
    f = [].concat(search),
    r = [].concat(replace),
    s = subject,
    ra = r instanceof Array, sa = s instanceof Array;    s = [].concat(s);
    if (count) {
        this.window[count] = 0;
    }
     for (i=0, sl=s.length; i < sl; i++) {
        if (s[i] === '') {
            continue;
        }
        for (j=0, fl=f.length; j < fl; j++) {            temp = s[i]+'';
            repl = ra ? (r[j] !== undefined ? r[j] : '') : r[0];
            s[i] = (temp).split(f[j]).join(repl);
            if (count && s[i] !== temp) {
                this.window[count] += (temp.length-s[i].length)/f[j].length;}        }
    }
    return sa ? s : s[0];
}

jQuery.fn.outerHTML = function() {
    return $('<div>').append( this.eq(0).clone() ).html();
};

jQuery.fn.Shake = function(speed, callback) {
  if(!speed || speed <= 0){
    speed = 1000;
  }
  this.each(function() {
    $(this).css({position:'relative'});
    var origLeft = parseInt($(this).css("left"), 5);
    for (var x=1; x<=4; x++) {
      $(this).animate({left:origLeft-(5)}, (((speed/4)/4)))
      .animate({left:origLeft+5}, ((speed/4)/2))
      .animate({left:origLeft}, (((speed/4)/4)));
    }
    if(typeof callback == 'function'){
      callback();
    }
  });
  return this;
};
