$(document).on('turbolinks:load', function(){
  $('.comment-form').on('click', '.comment-link', function(event){
    event.preventDefault();
    var commentedId = $(this).data('commentedId');
    var type = $(this).data('type');
    $(this).hide();
    $('form#comment-form-' + type + '-' + commentedId).removeClass('hidden');
    console.log('form#comment-form-' + type + '-' + commentedId)
  });

  $('.comments').on('click', '.edit-comment-link', function(event){
    event.preventDefault();
    var commentId = $(this).data('commentId');
    $(this).hide();
    $('#comment-text-' + commentId).hide();
    $('form#edit-form-comment-' + commentId).removeClass('hidden');
  });
});
