module PostsHelper
  def publisher_link(post)
    if post.publisher_type == 'User'
      link_to "#{post.publisher.firstname} #{post.publisher.lastname}", post.publisher
    else
      link_to "#{post.publisher.name}", post.publisher
    end
  end
end
