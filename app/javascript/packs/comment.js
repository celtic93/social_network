$(document).on('turbolinks:load', function(){
  $('.comments').on('click', '.comment-post-link', function(event){
    event.preventDefault();
    var postId = $(this).data('postId');
    $(this).hide();
    $('form#comment-form-post-' + postId).removeClass('hidden');
  });
});
