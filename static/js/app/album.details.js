/*
 * IMPORTANT!!!
 * REMEMBER TO ADD  rel="external"  to your anchor tags. 
 * If you don't this will mess with how jQuery Mobile works
 */
(function(window, $, PhotoSwipe) {

	$(document).ready(function() {

		var options = {};
		$("#Gallery a").photoSwipe(options);

	});

}(window, window.jQuery, window.Code.PhotoSwipe));
