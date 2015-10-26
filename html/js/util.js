function search_corp_name(name) {
  get_id_from_corp_name(name)
    .done(corp_lookup_action)
    .fail(ajax_fail);
}

// str -> promise
function get_id_from_corp_name (name) {
  var url = '/corplookup/' + name;
  return $.ajax({
    url: url,
    type: 'GET'
  });
}

function corp_lookup_action(ajax_data) {
  console.log(ajax_data);
}

// generates popup (modal) for each address
function names_popup(id, address) {
  $('.modal-title').text(address);
  $('#popup').modal();
  get_corporation_names(id)
    .done(insert_names)
    .fail(ajax_fail);
}

// array -> replaces .modal-body html
function insert_names(ajax_data) {
    console.log(ajax_data);
    var html = generate_corporate_names_html(ajax_data);
    $('.modal-body').html(html);
}

// array -> string
function generate_corporate_names_html(names) {
    var html = '<ul>';
    names.forEach(function(name){
      html += '<li>';
      html += name;
      html += '</li>';
    });
    html += '</ul>';
    return html;
}

// number -> promise
// ajax call for 
  function get_corporation_names (id) {
    var url = '/id/corpnames/' + id;
    return $.ajax({
      url: url,
      type: 'GET'
    });
  }

// -> logs to console
function ajax_fail() {
  console.error('AJAX FAIL :( :(');
  $('.modal-body').html('ajax error...email ziggy@elephant-bird.net and tell him nothing went wrong!');
}
