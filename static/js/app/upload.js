$(function() {
	$('#fileupload').fileupload({
		url : '/upload',
		dataType : 'json',

		add : function(e, data) {
			console.log("added data: %o", data);
			data.formData = {
				album_key : $('#album_key').val()
			}
			data.submit();
		},

		change : function(e, data) {
			console.log('change() data = %o', data);
			$.each(data.files, function(index, file) {
			});
		},
		done : function(e, data) {
			$.each(data.result.files, function(index, file) {
				$('<p/>').text(file.name).appendTo(document.body);
				console.log("file: %o", file)
			});
		},
		progressall : function(e, data) {
			var progress = parseInt(data.loaded / data.total * 100, 10);

			console.log("progress: %o", progress)
			$('.progressValue').width(progress + '%')
			$('.progressText').text(progress + '%')
		}
	});
});