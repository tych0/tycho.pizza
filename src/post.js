function generateAlert(type, msg) {
  return '<div class="alert alert-' + type + '">' +
    '<a class="close" data-dismiss="alert">x</a>' +
    '<strong>' + type + '!</strong> ' + msg + '</div>';
}

$(function() {
  $('form').submit(function() {
    $.ajax({
      type: "POST",
      url: "/comments.php",
      data: $('form').serialize(),
      success: function(data) {
        if(data.length != 0) {
          $('legend').append(generateAlert('error', data));
        }
        else {
          var success = 'Your post should be available in a few minutes.';
          $('form').replaceWith(generateAlert('success', success));
        }
      }
    })
  });
});
