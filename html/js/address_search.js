// generates popup (modal) for each address
function address_popup() {
  reset_address_search_dialog();
  var address = $('#address-search-input').val();
  var bor = $('#address-search-bor-select').val();
  var url = 'address/' + bor + '/' + encodeURIComponent(address.toUpperCase());
  var mapid;
  get(url)
    .done(function(data){
      if (data.regid === 'error') {
        deal_with_bad_address_not_in_db(address);
      } else if (data.status !== 'ok') {
        deal_with_no_corporate_owner(address);
      } else {
        update_address_search_modal_html(data);
        show_info();
        show_list_and_map();
        map(data.id, '#address-search-modal-map', function(map, id) {
          add_buildings(map, id, function(list_of_buildings) {
            $('#address-search-popup .modal-corp-list').html(genereate_building_list_html(list_of_buildings));
          });
        });
      }
    });

  // set title of popup and open it
  $('#address-result').text(address);
  $('#address-search-popup .modal-title').text(address);
  $('#address-search-popup').modal();

  function update_address_search_modal_html(data) {
      // update spans with result from AJAX
      $('.corporationname-result').text(data.corporationname);
      $('#business-address-result').text(data.businesshousenumber + ' ' + data.businessstreetname);
      $('#number-buildings-registered-result').text(data.buildingcount);
   }

  function deal_with_bad_address_not_in_db(address) {
    var message = 'was not found in the database. Check your spelling or try again with a new address';
    show_error(address, message);
  }

  function deal_with_no_corporate_owner(data) {
    var message = 'is registered with HPD, but has no corporate owner.';
    show_error(address, message);
  }
  
  function show_error(address, message) {
    var html = '<h5><strong>' + address + '</strong> ' + message + '</h5>';
    $('#address-search-popup .modal-error').html(html);
    hide_all_loading();
    hide_all_components();
    // show error
    $('#address-search-popup .modal-error').addClass('show').removeClass('hidden');
  }
  
   function genereate_building_list_html(buildings) {
    var html = '<ul>';
    buildings.forEach(function(building){
      html += '<li>' + building.h + ' ' + building.st + ', ' + building.b + ' (' + building.corp + ')' + '</li>';
    });
    return html;
  }

  function reset_address_search_dialog() {
    hide_all_components();
    show_all_loading();
  }

  function hide_all_loading() {
    $('#address-search-popup .info-loading').addClass('hidden').removeClass('show');
    $('#address-search-popup .modal-corp-list-loading').addClass('hidden').removeClass('show');
    $('#address-search-popup .modal-map-loading').addClass('hidden').removeClass('show'); 
  }

  function show_all_loading() {
    $('#address-search-popup .info-loading').addClass('show').removeClass('hidden');
    $('#address-search-popup .modal-corp-list-loading').addClass('show').removeClass('hidden');
    $('#address-search-popup .modal-map-loading').addClass('show').removeClass('hidden');
  }

  function hide_all_components() {
    $('#address-search-popup .info').addClass('hidden').removeClass('show');
    $('#address-search-popup .modal-corp-list').addClass('hidden').removeClass('show');
    $('#address-search-popup #address-search-modal-map').addClass('hidden').removeClass('show');
    $('#address-search-popup .modal-error').addClass('hidden').removeClass('show'); 
  }

  function show_info() {
    $('#address-search-popup .info').addClass('show').removeClass('hidden');
    $('#address-search-popup .info-loading').addClass('hidden').removeClass('show');
  }

  function show_list_and_map() {
    $('#address-search-popup .modal-corp-list-loading').addClass('hidden').removeClass('show');
    $('#address-search-popup .modal-map-loading').addClass('hidden').removeClass('show'); 
    $('#address-search-popup .modal-corp-list').addClass('show').removeClass('hidden');
    $('#address-search-popup #address-search-modal-map').addClass('show').removeClass('hidden');
  }
} 
