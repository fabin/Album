$(document).ready(function() {
	$('#freewall .brick img').each(function(index, value) {
		var w = 1 + 3 * Math.random() << 0;
		$(value).width(w * 150);
	});

	var wall = new freewall("#freewall");
	wall.reset({
		selector : '.brick',
		animate : true,
		cellW : 150,
		cellH : 'auto',
		onResize : function() {
			wall.fitWidth();
		}
	});

	var images = wall.container.find('.brick');
	var length = images.length;
	images.css({
		visibility : 'hidden'
	});
	images.find('img').load(function() {
		--length;
		if (!length) {
			setTimeout(function() {
				images.css({
					visibility : 'visible'
				});
				wall.fitWidth();
			}, 505);
		}
	});
});