class CommentsController < ApplicationController
  post '/posts/:post_id/comments' do
    redirect '/login' unless logged_in?
    post = Post.find_by(id: params[:post_id])
    if post
      comment = current_user.comments.build(
        content: params[:content],
        post: post,
        parent_id: params[:parent_id]
      )
      if comment.save
        notify_users(comment)
        flash[:success] = "Comment added successfully!"
      else
        flash[:error] = "Comment cannot be empty!"
      end
    end
    redirect "/posts/#{params[:post_id]}"
  end

  delete '/comments/:id' do
    comment = Comment.find_by(id: params[:id])
    if comment && (comment.user == current_user || comment.post.user == current_user)
      comment.destroy
      flash[:success] = "Comment deleted successfully!"
    else
      flash[:error] = "Unable to delete comment!"
    end
    redirect "/posts/#{comment.post_id}"
  end

  patch '/comments/:id' do
    comment = Comment.find_by(id: params[:id])
    if comment && comment.user == current_user
      if comment.update(content: params[:content])
        flash[:success] = "Comment updated successfully!"
      else
        flash[:error] = "Unable to update comment!"
      end
    end
    redirect "/posts/#{comment.post_id}"
  end

  private

  def notify_users(comment)
    mentioned_users = extract_mentions(comment.content)
    mentioned_users.each do |user|
      Notification.create(
        user: user,
        notifiable: comment,
        action: 'mentioned',
        actor: current_user
      )
    end

    if comment.parent_id
      parent_comment = Comment.find(comment.parent_id)
      Notification.create(
        user: parent_comment.user,
        notifiable: comment,
        action: 'replied',
        actor: current_user
      )
    end
  end

  def extract_mentions(content)
    usernames = content.scan(/@(\w+)/).flatten
    User.where(username: usernames)
  end
end