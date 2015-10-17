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


// GETS list of corporation for selected corporate address
// takes the 'id' of the selected row, does ajax request to /id/:id, and replaces html of div#corporation-names with new html
function corporation_names(id, address) {
    get_corporation_names(id)
    .done(insert_names)
    .fail(ajax_fail);


// these functions for corporation_names() follow this pattern:
// ajax -> generate_html -> insert into dom 
// get_corporation_names -> generate_corporate_names_html -> names_in_dom

  // array -> inserts into dom
  function insert_names(ajax_response_data) {
    var html = generate_corporate_names_html(ajax_response_data);
    dialog(html, address);
    //names_in_dom(html);
  }


  // string -> inserts into dom
  function names_in_dom(html) {
    $( '#corporation-names' ).html(html);
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
  function get_corporation_names (id) {
    var url = '/id/corpnames/' + id;
    return $.ajax({
      url: url,
      type: 'GET'
    });
  }

}

//shared functions

// -> logs to console
function ajax_fail() {
  console.error('AJAX FAIL :( :(');
}
