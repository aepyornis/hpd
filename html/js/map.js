// creates map in #map-div
function map(id, mapdiv, callback) {
  var mapID = 'map-' + id;
  $(mapdiv).html('<div id="' + mapID +'"></div>');
  $("#" + mapID).css('height', '350px');
  $("#" + mapID).css('width', '98%');
  
  var map = L.map(mapID).setView([40.731864, -73.935288], 11);
  L. tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',{}).addTo(map);

  if (callback && typeof callback === 'function') {
    callback(map, id);
  }
}

// style for buildings marker
var circleMarkerStyle = {
  radius: 8,
  fillColor: '#1f78b4',
  fillOpacity: 0.8,
  color: '#fff'
}

// input: leaflet-map object, id, callback(ajax_data)
function add_buildings(map, id, callback) {
   get('id/buildings/'+ id)
    .done(add_all_the_buildings_to_the_map)
    .fail(ajax_fail);
  
  function add_all_the_buildings_to_the_map(list_of_buildings) {
    list_of_buildings.forEach(function(building){
      if (building.lat && building.lng) {
        put_a_building_on_the_map([building.lat, building.lng], circleMarkerStyle, building);
      }
    });
    if (callback && typeof callback === 'function') {
      callback(list_of_buildings);
    }
  }
  
  function put_a_building_on_the_map(geo, style, building) {
    L.circleMarker(geo, style).bindPopup(popup_html(building)).addTo(map);
  }

  function popup_html(building) {
    var html = '<p><strong>Address: </strong>';
    html += building.h + ' ' + building.st + ', ' + building.b + ', ' + building.zip;
    html += '</p>';
    html += '<p><strong>Corp name: </strong>' + building.corp + '</p>';
    return html;
  }
}

function add_hq(map, id) {
  get('/id/latlng/' + id)
    .done(add_marker_to_map_and_pan);

  function add_marker_to_map_and_pan(geo) {
    if (geo) {
      L.marker(geo).addTo(map);
      map.panTo(geo);
    }
  }

}





