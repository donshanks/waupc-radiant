
$j('#ss1').cycle({
  fx: 'fade',
  speed: 3600
});
$j(function(){
  var menus = $j('.topmenu > li');
  $j.each(menus,function(i,e){ 
    if(i==3) $j(e).addClass('sections');
    if(i==5) $j(e).addClass('last'); 
  });
  $j('h3').each(function(i,e){ 
    if( !$j(e).hasClass('nocorners') ){
      $j(e).corner("bottom 10px"); 
    }
  });
  $j('.read-more').click(function(){
    $j('#'+this.id+'-more').slideToggle('slow');
    var e = $j(this);
    if( e.text().match(/Read/) ) {
      e.text( e.text().replace('Read','Hide') );
    }
    else {
      e.text( e.text().replace('Hide','Read') );
    }
  });
  $j('.church-line').click(function(){
    $j('#'+this.id+'_more').dialog({
      modal: true,
      width: 400
    });
  });
});
