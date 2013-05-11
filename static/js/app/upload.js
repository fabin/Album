$(function() {
	$('#fileupload').fileupload({
		url : '/upload',
		dataType : 'json',

		add : function(e, data) {
			data.formData = {
				album_key : $('#album_key').val()
			}
			data.submit();
		},

		change : function(e, data) {
			$.each(data.files, function(index, file) {
			});
		},
		done : function(e, data) {
			$.each(data.result.files, function(index, file) {
				$('<p/>').text(file.name).appendTo(document.body);
			});
		},
		progressall : function(e, data) {
			var progress = parseInt(data.loaded / data.total * 100, 10);

			$('.progressValue').width(progress + '%')
			$('.progressText').text(progress + '%')
		}
	});
});