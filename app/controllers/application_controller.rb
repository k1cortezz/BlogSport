class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET'] || 'secret'
  end

  get '/' do
    @posts = Post.order(created_at: :desc).limit(10)
    erb :index
  end

  get '/updates' do
    erb :updates
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end