# file: app.rb

require_relative './lib/database_connection'
require_relative './lib/album_repository'
require_relative './lib/artist_repository'
require 'sinatra/base'
require 'sinatra/reloader'



class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

   get '/' do
        return 'Hello'
  end

get '/albums/new' do
  return erb(:new_album)
end

get '/artists/new' do
  return erb(:new_artist)
end

  post '/albums' do
    @title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    new_album = Album.new
    new_album.title = @title
    new_album.release_year = release_year
    new_album.artist_id = artist_id
    AlbumRepository.new.create(new_album)
      return erb(:album_created)
  end

  post '/artists' do
    @name = params[:name]
    genre = params[:genre]
    
 
    new_artist = Artist.new
    new_artist.name = @name
    new_artist.genre = genre
    ArtistRepository.new.create(new_artist)
     return erb(:artist_created)
   end


  get '/albums' do 
    repo = AlbumRepository.new 
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/:id' do 
    repo = AlbumRepository.new 
    artist_repo = ArtistRepository.new
   
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end

  get '/artists/:id' do 
    repo = ArtistRepository.new 
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  get '/artists' do 
    repo = ArtistRepository.new 
    @artists = repo.all
    return erb(:artists)
  end
end


=begin 
  # The Application class initializer
  # takes four arguments:
  #  * The database name to call `DatabaseConnection.connect`
  #  * the Kernel object as `io` (so we can mock the IO in our tests)
  #  * the AlbumRepository object (or a double of it)
  #  * the ArtistRepository object (or a double of it)
  def intialize(database_name, io, album_repository, artist_repository)
    # We need to give the database name to the method `connect`.
    DatabaseConnection.connect(database_name)
    @io = io
    @album_repository = album_repository
    @artist_repository = artist_repository
  end

  def run
    # "Runs" the terminal application
    # so it can ask the user to enter some input
    # and then decide to run the appropriate action
    # or behaviour.

    # Use `@io.puts` or `@io.gets` to
    # write output and ask for user input.
  end
end

# Don't worry too much about this if statement. It is basically saying "only
# run the following code if this is the main file being run, instead of having
# been required or loaded by another file.
# If you want to learn more about __FILE__ and $0, see here: https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Pre-defined_Variables
if __FILE__ == $0
  app = Application.new(
    'music_library_db_test',
    Kernel,
    AlbumRepository.new,
    ArtistRepository.new
  )
  app.run
end
=end
