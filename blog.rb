require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'


set :database, "sqlite3:test.sqlite3"
enable :sessions

def current_user
	if session[:user_id]
		current_user = User.find(session[:user_id])
	end
end




# Home View
get '/' do 


 erb :home
	
end




# show users
get '/users' do
	@user = User.all
	erb :users
end

# show user by id

get '/user/:id' do
	if current_user == nil
		redirect '/'
	end

	if current_user != current_user
		redirect '/'
	end

	if current_user == current_user
	# @user = User.find(params['id'])
	@user = current_user
	@posts = Post.where(user_id: params["id"])
	erb :user
end

end

get '/user' do
	@user = session[:user_id]
end



get '/new_user/new' do
	erb :new_user
end

# create user
post '/new_user/create' do
	@user = User.create(params)
	# redirect "/users/#{@user.id}"
	redirect "/"
end

#sign in
get '/signin' do
	erb :signin
end


#actual log in
post '/login' do
	@user = User.where(username: params['username']).first
	if @user && @user.password == params['password']
		session[:user_id] = @user.id
		flash[:notice] = "You Logged In!"
		redirect "/user/#{session[:user_id]}"

	else 
		flash[:alert] = "Nope, Try again."
		redirect "/"
	end
end


#logout

get '/logout' do
	erb :logout
end

post '/logout' do
	session[:user_id] = nil
	redirect "/"
end



# Start Posts

get '/posts' do
	@posts = Post.all

	erb :allposts

end

# View Posts by id






# Create A Post

get '/posts/new' do
	erb :post
end


post '/posts/create' do
	posts = Post.new(params)
	posts.user_id = session[:user_id]
	posts.save
	redirect "/user/#{session[:user_id]}"
end


# Delete a Post

# using Post.where has to be a key value pair. ex: 
# posts = Post.where(user_id: session[:user_id]).first
# first targets the first one in the array. 
# posts = Post.find_by_user_id(session[:user_id])

post '/posts/destroy' do

	posts = Post.where(user_id: session[:user_id]).last
	posts.delete
	redirect "/user/#{session[:user_id]}"

end


# Update Account Details

get '/user/:id/update' do
	@user = User.find(session[:user_id])
	erb :update

end

post '/user/:id/update' do
	@user = User.find(session[:user_id])
	@user.update(username: params['username'], email: params['email'], password: params['password'])
	redirect "/user/#{session[:user_id]}"
end


# Destroy a user

post '/user/:id/destroy' do
	@user = User.find(session[:user_id])
	@user.delete
	session.clear
	redirect "/"
end







