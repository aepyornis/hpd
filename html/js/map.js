function map(id) {
  var mapID = 'map-' + id;
  $("#modal-map").html('<div id="' + mapID +'"></div>');
  $("#" + mapID).css('height', '200px');
  $("#" + mapID).css('width', '100%');
  
  var map = L.map(mapID).setView([40.731864, -73.935288], 13);
  L. tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',{}).addTo(map);
  
}








