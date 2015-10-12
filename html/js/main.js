$(document).ready(function() {
  $('#top500-table').DataTable( {
    "ajax": "data/top500.txt",
    "columns": [
      { "data": "a" },
      { "data": "zip" },
      { "data": "num" }
    ]
  });
});
