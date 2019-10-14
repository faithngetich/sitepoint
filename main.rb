require 'sinatra'
require 'data_mapper'
require 'slim'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

get '/' do
  @tasks = Task.all
  slim :index
end

get '/:task' do
  @task = params[:task].split('-').join(' ').capitalize
  slim :task
end

post '/' do
  Task.create  params[:task]
  redirect to('/')
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to('/')
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end

class Task
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  property :completed_at, DateTime
end
DataMapper.finalize