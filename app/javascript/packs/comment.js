$(document).on('turbolinks:load', function(){
  $('.comment-form').on('click', '.comment-post-link', function(event){
    event.preventDefault();
    var postId = $(this).data('postId');
    $(this).hide();
    $('form#comment-form-post-' + postId).removeClass('hidden');
  });

  $('.comments').on('click', '.edit-comment-link', function(event){
    event.preventDefault();
    var commentId = $(this).data('commentId');
    $(this).hide();
    $('#comment-text-' + commentId).hide();
    $('form#edit-form-comment-' + commentId).removeClass('hidden');
  });
});
