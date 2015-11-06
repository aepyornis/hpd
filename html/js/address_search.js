
// generates popup (modal) for each address
function address_popup() {
  var address = $('#address-search-input').val();
  var bor = $('#address-search-bor-select').val();
  var url = 'address/' + bor + '/' + encodeURIComponent(address);
  get(url)
    .done(function(data){
      console.log(data);
      update_address_search_modal_html(data);
    });

  $('#address-result').text(address);
  $('#address-search-popup .modal-title').text(address);
  $('#address-search-popup').modal();

  function update_address_search_modal_html(data) {
    $('.corporationname-result').text(data.corporationname);
    $('#business-address-result').text(data.businesshousenumber + ' ' + data.businessstreetname);
    $('#number-buildings-registered-result').text(data.buildingcount);
  }
}
