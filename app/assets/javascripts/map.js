var initMap = function () {
  var mapOptions = { maxZoom: 16 }
  var handler = Gmaps.build('Google');

  handler.buildMap({ provider: mapOptions, internal: {id: 'map'}}, function(){
    markers_json = gon.geocoded_hash;
    markers = _.map(markers_json, function(marker_json){
      marker = handler.addMarker(marker_json);
      _.extend(marker, marker_json);

      google.maps.event.addListener(
        marker.getServiceObject(),
        "click",
        onMarkerClick(marker, event)
      )
      
      return marker;
    });

    // markers = handler.addMarkers(gon.geocoded_hash);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(12);
  });

  function onMarkerClick(marker, event){
    return function(event){
      $("#map-footer").show();
      $("#map-footer .card-content .name").text(marker.name);
      $("#map-footer .card-content .about").html(marker.about.substring(0, 90) + "...");

      $("#map-footer .card-content .tags").html(
        _.map(marker.tags, function(tag){
          return("<a href='/schools?tag_id=" +
            tag[0] +
            "'>" +
            tag[1] +
            "</a>"
          )}).join(" ")
      );

      $("#map-footer .card-action .link").attr("href", "/schools/" + marker.id);
    }
  }
}

$(document).ready(function() {
  $('ul.tabs').tabs();
  initMap();

  // When the map tab is clicked, poll every 100ms until the #map div is visible
  // and then render the map. This is hacky but works. Ideas for better ways:
  // http://stackoverflow.com/questions/1225102/jquery-event-to-trigger-action-when-a-div-is-made-visible
  $('li.tab a#map-show-link').click(function() {
    var int = setInterval(function() {
      if($("#map:visible").length > 0) {
        initMap();
        clearInterval(int);
      }
    }, 100);
  });
});

