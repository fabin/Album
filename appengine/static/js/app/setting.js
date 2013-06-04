$(function() {
	'use strict';
	// Change this to the location of your server-side upload handler:
	initUploadItem('#fileuploadHead', '#appHead', 'img#head', '=s120-c');
	initUploadItem('#fileuploadWelcome', '#appWelcome', 'img#welcomeImage',
			'=s360');
	initUploadItem('#fileuploadCongratulation', '#appCongratulation',
			'img#congratulationImage', '=s480');
	initUploadItem('#fileuploadCover', '#cover', 'img#coverImage', '=s1600');

	$('#update').click(function() {
		var info = $('.alert-success');
		if (info.length >= 0) {
			info.remove()
		}
		$('#form').submit();
	});

	$('.nav-tabs li a').each(function(index) {
		console.log($(this).attr('href'))
		var $a = $(this);
		var $li = $(this).parent();
		$a.click(function() {
			hiddenAllTabContent();
			$li.addClass('active');
			var id = $a.attr('href');
			$(id).css({
				display : 'block'
			})
			return false;
		});
	});
	$('.nav-tabs li.active a').click();
});

function hiddenAllTabContent() {
	$('.nav-tabs li a').each(function(index) {
		var $li = $(this).parent();
		$li.removeClass('active');
		var id = $(this).attr('href');
		console.log('hiddening ' + id)
		$(id).css({
			'display' : 'none'
		});
	});
}
function initUploadItem(trigger, hiddenInput, img, tail) {
	$(trigger).fileupload({
		url : '/settings/upload',
		dataType : 'json',
		add : function(e, data) {
			$('#progress .bar').css('width', '0%');
			var info = $('.alert-success');
			if (info.length >= 0) {
				info.remove()
			}

			data.submit();
		},
		done : function(e, data) {
			console.log('data.result = %o', data.result);
			$.each(data.result, function(index, file) {
				console.log('file = %o', file);
				$(hiddenInput).val(file.url);
				$(img).attr('src', file.url + tail)
			});
		},
		progressall : function(e, data) {
			var progress = parseInt(data.loaded / data.total * 100, 10);
			$('#progress .bar').css('width', progress + '%');
		}
	});
}