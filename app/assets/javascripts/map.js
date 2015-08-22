$(document).ready( function() {
  var handler = Gmaps.build('Google');
  console.log(gon.geocoded_hash);
  handler.buildMap({ internal: {id: 'map'}}, function(){
    var markers = handler.addMarkers(gon.geocoded_hash);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  });
});
