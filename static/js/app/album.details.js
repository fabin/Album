/*
 * IMPORTANT!!!
 * REMEMBER TO ADD  rel="external"  to your anchor tags. 
 * If you don't this will mess with how jQuery Mobile works
 */
(function(window, $, PhotoSwipe) {

	$(document).ready(function() {

		var options = {};
		var images = $("#Gallery a");
		if (images.length > 0) {
			images.photoSwipe(options);
		}

		$('#delete').click(function() {
			return confirm('确定要删除吗？');
		});
	});

}(window, window.jQuery, window.Code.PhotoSwipe));
