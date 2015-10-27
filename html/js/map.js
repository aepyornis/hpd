function map(id) {
  var mapID = 'map-' + id;
  $("#modal-map").html('<div id="' + mapID +'"></div>');
  $("#" + mapID).css('height', '200px');
  $("#" + mapID).css('width', '100%');
  
  var map = L.map(mapID).setView([40.731864, -73.935288], 13);
  L. tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',{}).addTo(map);

  add_hq(map, id);
}


function add_hq(map, id) {
  get('/id/latlng/', id)
    .done(add_marker_to_map);

  function add_marker_to_map(geo) {
    L.marker(geo).addTo(map);
  }

}

function get(url, id) {
  return $.ajax({
    url: url + id,
    type: 'GET'
  });
}





