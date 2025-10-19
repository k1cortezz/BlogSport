class BookmarksController < ApplicationController
  post '/posts/:post_id/bookmark' do
    redirect '/login' unless logged_in?
    post = Post.find_by(id: params[:post_id])
    
    if post
      bookmark = current_user.bookmarks.find_or_initialize_by(post: post)
      if bookmark.new_record?
        bookmark.save
        flash[:success] = "Post bookmarked!"
      else
        bookmark.destroy
        flash[:success] = "Bookmark removed!"
      end
    end
    
    redirect back
  end

  get '/bookmarks' do
    redirect '/login' unless logged_in?
    @bookmarks = current_user.bookmarks.includes(:post).order(created_at: :desc)
    erb :'bookmarks/index'
  end
end