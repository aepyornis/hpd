// generates popup (modal) for each address
function address_popup() {
  var address = $('#address-search-input').val();
  var bor = $('#address-search-bor-select').val();
  var url = 'address/' + bor + '/' + encodeURIComponent(address.toUpperCase());
  var mapid;
  get(url)
    .done(function(data){
      if (data.regid === 'error') {
        deal_with_bad_address_not_in_db(address);
      } else {
        update_address_search_modal_html(data);
        mapid = data.id;
        get('/id/buildings/' + data.id)
          .done(update_buildings_list_and_add_map);
      }
    });

  
  // set title of popup and open it
  $('#address-result').text(address);
  $('#address-search-popup .modal-title').text(address);
  $('#address-search-popup').modal();

  function update_address_search_modal_html(data) {
    // hide error, display info
    $('#address-search-popup .modal-body .info').addClass('show').removeClass('hidden');
    $('#address-search-popup .modal-error').addClass('hidden').removeClass('show');
    // update spans with result from AJAX
    $('.corporationname-result').text(data.corporationname);
    $('#business-address-result').text(data.businesshousenumber + ' ' + data.businessstreetname);
    $('#number-buildings-registered-result').text(data.buildingcount);
  }

function deal_with_bad_address_not_in_db(address) {
  var html = '<h5><strong>' + address + '</strong> was not found in the database. Check your spelling or try again with a new address</h5>';
  $('#address-search-popup .modal-error').html(html);
  // show error, hide info
  $('#address-search-popup .modal-error').addClass('show').removeClass('hidden');
  $('#address-search-popup .modal-body .info').addClass('hidden').removeClass('show');
}

function update_buildings_list_and_add_map(ajax_data) {
  $('#address-search-popup .modal-corp-list').html(genereate_building_list_html(ajax_data));
  map(mapid, '#address-search-modal-map');
}

function genereate_building_list_html(buildings) {
  var html = '<ul>';
  buildings.forEach(function(building){
    html += '<li>' + building.h + ' ' + building.st + ', ' + building.b + ' (' + building.corp + ')' + '</li>';
  });
  return html;
}

}
