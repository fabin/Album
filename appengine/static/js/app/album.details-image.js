$(document).ready(function() {
	$('#freewall .cell').each(function(index, value) {
		var w = 200 + 200 * Math.random() << 0;
		$(value).width(w);
		$(value).height(200);
	});

	var wall = new freewall("#freewall");
	wall.reset({
		selector : '.cell',
		animate : true,
		cellW : 20,
		cellH : 200,
		onResize : function() {
			wall.fitWidth();
		}
	});
	wall.fitWidth();
	// for scroll bar appear;
	$(window).trigger("resize");
});