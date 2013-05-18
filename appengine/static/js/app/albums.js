/*
 * IMPORTANT!!!
 * REMEMBER TO ADD  rel="external"  to your anchor tags. 
 * If you don't this will mess with how jQuery Mobile works
 */
$(document).ready(function() {

	$('#albums .album').each(function(index) {
		$(this).addClass('albumTopColor-' + (index % 6));
	});
//	$('#cover .profile .details .head img').each(function(index) {
//		$(this).corner('60px');
//	});
//	$('#albums .album').each(function(index) {
//		$(this).corner('3px');
//	});

});
