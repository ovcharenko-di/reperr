$('a.list-group-item').on( 'click', function(e){
    $(this).addClass('active').siblings().removeClass('active');
});