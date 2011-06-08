require 'sinatra'
require 'haml'
require 'rack-flash'

require 'bson'
require 'mongo'
require 'mongo_mapper'

# CodeRay for Syntax HIghlighting
require 'coderay'

# SecureRandom for Slug generation
require 'securerandom'

require_relative 'config'
require_relative 'lib/scanners/ninja'

configure do
  MongoMapper.connection= Mongo::Connection.new('localhost')
  MongoMapper.database= 'gopaste'
end

enable :sessions

helpers do
  use Rack::Flash

  def get_language_name name
    LANGUAGES.key(name.to_sym)
  end
end

# require Models
require_relative 'models/Paste'

layout 'layout'

get '/' do
  @languages = LANGUAGES.sort
  haml :home
end

post '/add' do
  paste = Paste.new
  paste.name = params[:name] unless params[:name].blank?
  paste.author = params[:author] unless params[:author].blank?
  paste.language = params[:language]
  paste.code = params[:code]
  paste.save
  redirect '/paste/' + paste.slug
end

get '/search' do
  haml :search
end

post '/search' do
  haml :search_results, :layout => (request.xhr? ? false : :layout)
end

get '/paste/:slug' do
  @paste = Paste.where(:slug => params[:slug]).first
  haml :paste
end

get '/recent' do
  # Load latest 10 pastes
  @pastes = Paste.sort(:created_at.desc).limit(10).all
  haml :recent
end

get '/about' do
  haml :about
end