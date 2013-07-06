$(document).ready(function() {

	$('ul#Gallery li a').smoothScroll({
		speed : 1000,
		easing : 'easeInOutCubic'
	});

	$('.showOlderChanges').on('click', function(e) {
		$('.changelog .old').slideDown('slow');
		$(this).fadeOut();
		e.preventDefault();
	})

	$('#delete').click(function() {
		return confirm('确定要删除吗？');
	});
});