$(document).on('turbolinks:load', function(){
  $('.posts').on('click', '.edit-post-link', function(event){
    event.preventDefault();
    var postId = $(this).data('postId');
    $(this).hide();
    $('#post-' + postId).hide();
    $('form#edit-post-' + postId).removeClass('hidden');
  });
});
