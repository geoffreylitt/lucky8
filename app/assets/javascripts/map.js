var initMap = function () {
  var mapOptions = { maxZoom: 16 }
  var handler = Gmaps.build('Google');
  handler.buildMap({ provider: mapOptions, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers(gon.geocoded_hash);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(12);
  });
}

$(document).ready(function() {
  $('ul.tabs').tabs();

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

