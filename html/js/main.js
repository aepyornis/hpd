$(document).ready(function() {
  var table = $('#top500-table').DataTable( {
    "ajax": "data/top500.txt",
    "columns": [
      { "data": "a" },
      { "data": "zip" },
      { "data": "num" },
      //hide the 'id' column; id is used later
      {
        "data": "id",
        "visible": false,
       "searchable": false
      }
      
    ],
    "order": [[2, "desc"]],
    // enable select and only allow one selection at a time
    "select": {
      "style": 'single'
    }
    
  });

  // listen for select event
  table.on( 'select', function ( e, dt, type, index ) {
    // this grabs selected row's id
    var id = table.row(index[0]).data().id;
    corporation_names(id);
   });
});

// gets list of corporation for selected corporate address
// takes the 'id' of the selected row, does ajax request to /id/:id, and replaces html of div#corporation-names with new html
function corporation_names(id) {
    get_corporation_names(id)
    .done(insert_names)
    .fail(insert_names_fail);
}

// these functions for corporation_names() follow this pattern:
// ajax -> generate_html -> insert into dom 
// get_corporation_names -> generate_corporate_names_html -> names_in_dom

// array -> inserts into dom
function insert_names(ajax_response_data) {
  var html = generate_corporate_names_html(ajax_response_data);
  names_in_dom(html);
}

// -> logs to console
function insert_names_fail() {
  console.error('AJAX FAIL :( :(');
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

