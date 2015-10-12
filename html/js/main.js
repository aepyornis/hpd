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
    table.row(index[0]).data().id
          
  });
  
});

