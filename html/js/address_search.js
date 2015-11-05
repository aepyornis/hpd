// generates popup (modal) for each address
function address_popup() {
  var address = $('#address-search-input').val();
  $('#address-search-popup .modal-title').text(address);
  $('#address-search-popup').modal();
}
