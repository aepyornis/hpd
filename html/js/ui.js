// dialog popup for 
function dialog (html, title){
  $(document.createElement('div')).html(html).dialog({
    maxHeight: 300,
    title: title
  }); 
}

