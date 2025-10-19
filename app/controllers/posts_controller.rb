class PostsController < ApplicationController
  get '/posts' do
    @posts = Post.all.order(created_at: :desc)
    erb :'posts/index'
  end

  get '/posts/new' do
    redirect '/login' unless logged_in?
    @tags = Tag.all
    erb :'posts/new'
  end

  post '/posts' do
    redirect '/login' unless logged_in?
    post = current_user.posts.build(params[:post])
    if post.save
      params[:tags]&.each do |tag_id|
        PostTag.create(post: post, tag_id: tag_id)
      end
      redirect "/posts/#{post.id}"
    else
      redirect '/posts/new'
    end
  end

  get '/posts/:id' do
    @post = Post.find_by(id: params[:id])
    erb :'posts/show'
  end

  get '/posts/:id/edit' do
    @post = Post.find_by(id: params[:id])
    redirect '/posts' unless @post && @post.user == current_user
    @tags = Tag.all
    erb :'posts/edit'
  end

  patch '/posts/:id' do
    post = Post.find_by(id: params[:id])
    redirect '/posts' unless post && post.user == current_user
    
    if post.update(params[:post])
      post.post_tags.destroy_all
      params[:tags]&.each do |tag_id|
        PostTag.create(post: post, tag_id: tag_id)
      end
      redirect "/posts/#{post.id}"
    else
      redirect "/posts/#{post.id}/edit"
    end
  end

  delete '/posts/:id' do
    post = Post.find_by(id: params[:id])
    post.destroy if post && post.user == current_user
    redirect '/posts'
  end
end