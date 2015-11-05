
// generates popup (modal) for each address
function address_popup() {
  var address = $('#address-search-input').val();
  var bor = $('#address-search-bor-select').val();
  var url = 'address/' + bor + '/' + encodeURIComponent(address);
  get(url)
    .done(function(data){
      console.log(data);
    })
  
  $('#address-search-popup .modal-title').text(address);
  $('#address-search-popup').modal();
}


