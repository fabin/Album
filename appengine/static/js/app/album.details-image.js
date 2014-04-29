$(document).ready(function() {
	$('#freewall .cell').each(function(index, value) {
		var w = 300 + 200 * Math.random() << 0;
		$(value).width(w);
		$(value).height(200);
	});

	var wall = new freewall("#freewall");
	wall.reset({
		selector : '.cell',
		animate : true,
		cellW : 20,
		cellH : 300,
		onResize : function() {
			wall.fitWidth();
		}
	});
	wall.fitWidth();
	// for scroll bar appear;
	$(window).trigger("resize");
	
	$('.fancybox').fancybox();
});