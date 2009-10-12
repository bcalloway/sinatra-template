require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'haml'
require 'rack-flash'
require 'openssl'

  DataMapper.setup(
    :default,
    {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'DATABASE',
    :socket   => '/var/mysql/mysql.sock'
  })

  class User
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :created_at, DateTime
    property :updated_at, DateTime

    validates_present :name
    
  end

  enable :sessions
  
  DataMapper.auto_upgrade!
  use Rack::Flash

  helpers do
    def view(view)
      haml view
    end
  end

  get '/stylesheets/screen.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :screen
  end
  
  # show all
  get '/' do
    @user = User.all(:order => [:name.asc])
    view :index
  end
  
  # new
  get '/new' do
    view :new
  end

  # create
  post '/create' do
    @user = User.new(
      :name   => params[:name]
      )
    if @user.save
      flash[:notice] = "A new record has been added to the database"
      redirect "/"
    else
      @user.errors.each do |e|
        flash[:error] = e
      end
      redirect '/new'
    end
  end

  # show
  get '/:id' do
    @user = User.get(params[:id])
    view :show
  end
  
  # edit
  get '/edit/:id' do
    @user = User.get(params[:id])
    view :edit
  end

  # update
  post '/update/:id' do
    @user = User.get(params[:id])
    if @user.update_attributes(
      :name    => params[:name]
    )
      flash[:notice] = "The record has been updated."
      redirect '/'
    else
      redirect '/edit'
    end
  end

  # delete and protect RESTful path
  delete '/users/' do
    id = params[:id]
    v = User[id]
    v.destroy
    flash[:notice] = "The record has been deleted."
    redirect '/'
  end